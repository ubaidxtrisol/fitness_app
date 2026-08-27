import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/views/challenge_day_screen.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// [ChallengeDayScreen] reads its mid-workout checkpoint from
/// [ActiveSessionRepository] in initState, which hits Drift; per the
/// project's testing notes, Drift's futures complete on real timers the fake
/// clock never advances under `testWidgets`, so every pump here runs inside
/// `tester.runAsync`.
ExerciseModel _exercise(String id, String title) => ExerciseModel(
  order: 1,
  exerciseId: id,
  title: title,
  description: '',
  durationSeconds: 35,
  reps: 0,
  restSeconds: 0,
  thumbnailUrl: '',
  videoUrl: '',
  howToDo: const [],
  commonMistakes: const [],
  breathingTips: const [],
);

DayModel _day() => DayModel(
  id: 'day_1',
  title: 'Day 1',
  difficulty: 'Beginner',
  durationMinutes: 6,
  netTimeMinutes: 5,
  caloriesBurned: 45,
  thumbnailUrl: '',
  exercises: [
    _exercise('ex_a', 'Glute Bridge'),
    _exercise('ex_b', 'Plank'),
    _exercise('ex_c', 'Lunge'),
  ],
);

ChallengeWeekModel _week(DayModel day) => ChallengeWeekModel(
  id: 'week_1',
  title: 'Week 1',
  subtitle: 'Subtitle',
  currentDayIndex: 0,
  days: [day],
);

ChallengeProgramModel _challenge(ChallengeWeekModel week) => ChallengeProgramModel(
  id: 'chal_test',
  titleLead: 'Test ',
  titleAccent: 'Challenge',
  title: 'Test Challenge',
  daysLabel: '1 Days',
  userCount: '1 User',
  thumbnailUrl: '',
  weeks: [week],
);

Widget _host(Widget child) => MaterialApp(home: child);

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
  });

  tearDown(() async => db.close());

  testWidgets('a fresh day shows no badges and a plain Start button', (
    tester,
  ) async {
    final day = _day();
    final week = _week(day);
    final challenge = _challenge(week);

    // Tall enough that all three exercise rows are realized — the day
    // screen's content comfortably overflows the default test surface.
    tester.view.physicalSize = const Size(393, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        _host(
          ChallengeDayScreen(challenge: challenge, week: week, day: day, weekNumber: 1),
        ),
      );
      await tester.pump();
      await tester.pump();
    });

    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Resume'), findsNothing);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
    expect(find.textContaining('/3'), findsNothing);
  });

  testWidgets(
    'a mid-workout checkpoint marks the done exercise and offers Resume',
    (tester) async {
      final day = _day();
      final week = _week(day);
      final challenge = _challenge(week);

      await ActiveSessionRepository(db).save(
        planId: 'chal_test/week_1',
        dayId: 'day_1',
        planType: PlanType.challenge,
        planTitle: 'Test Challenge',
        dayTitle: 'Day 1',
        completedExerciseIds: ['ex_a#0'],
        elapsedSeconds: 40,
        startedAt: DateTime(2026, 1, 1),
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(
          _host(
            ChallengeDayScreen(challenge: challenge, week: week, day: day, weekNumber: 1),
          ),
        );
        await tester.pump();
        await tester.pump();
      });

      expect(find.text('Resume'), findsOneWidget);
      expect(find.text('Start'), findsNothing);
      expect(find.text('1/3'), findsOneWidget);
      expect(
        find.byIcon(Icons.check_rounded),
        findsOneWidget,
        reason: 'only the logged exercise gets the completed badge',
      );
    },
  );

  testWidgets(
    'a day already finished on a prior run shows every exercise done and a Completed badge',
    (tester) async {
      final day = _day();
      final week = _week(day);
      final challenge = _challenge(week);

      tester.view.physicalSize = const Size(393, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          _host(
            ChallengeDayScreen(
              challenge: challenge,
              week: week,
              day: day,
              weekNumber: 1,
              isCompleted: true,
            ),
          ),
        );
        await tester.pump();
        await tester.pump();
      });

      expect(find.text('Completed'), findsOneWidget);
      expect(
        find.text('Start'),
        findsOneWidget,
        reason: 'replaying a finished day is still a plain Start, not Resume',
      );
      expect(find.text('Resume'), findsNothing);
      expect(
        find.byIcon(Icons.check_rounded),
        findsNWidgets(3),
        reason: 'every exercise in a finished day counts as done',
      );
    },
  );
}
