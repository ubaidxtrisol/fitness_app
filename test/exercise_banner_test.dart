import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget cover for the exercise detail screen's static banner (Figma
/// 16:374-377), which replaced a live video preview.
///
/// The screen reads a cached duration via [ExercisePrefsRepository] in
/// initState, which hits Drift; per the project's testing notes, Drift's
/// futures complete on real timers the fake clock never advances under
/// `testWidgets`, so every pump here runs inside `tester.runAsync`.
ExerciseModel _exercise({
  String thumb = 'https://example.com/a.jpg',
  String title = 'Pilates Glute Bridge',
}) => ExerciseModel(
  order: 1,
  exerciseId: 'ex_a',
  title: title,
  description: '',
  durationSeconds: 45,
  reps: 0,
  restSeconds: 0,
  thumbnailUrl: thumb,
  videoUrl: 'https://example.com/a.mp4',
  howToDo: const [],
  commonMistakes: const [],
  breathingTips: const [],
);

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
  });

  tearDown(() async => db.close());

  testWidgets('the detail screen shows a static banner, no video controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(home: ExerciseDetailScreen(exercise: _exercise())),
      );
      await tester.pump();
      await tester.pump();
    });

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    expect(find.byIcon(Icons.pause_rounded), findsNothing);
    expect(find.byIcon(Icons.replay_5_rounded), findsNothing);
    expect(find.byIcon(Icons.forward_5_rounded), findsNothing);
    expect(find.text('Pilates Glute Bridge'), findsAtLeastNWidgets(1));
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Start Now · 00:45'), findsOneWidget);
  });

  testWidgets('a long title wraps inside the banner without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExerciseDetailScreen(
            exercise: _exercise(
              title: 'Side Lying Leg Circles Both Directions',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
    });

    expect(tester.takeException(), isNull);
  });

  testWidgets('a missing thumbnail leaves the banner background alone', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(home: ExerciseDetailScreen(exercise: _exercise(thumb: ''))),
      );
      await tester.pump();
      await tester.pump();
    });

    expect(tester.takeException(), isNull);
  });
}
