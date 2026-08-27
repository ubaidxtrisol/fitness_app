import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/home/services/next_up_service.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:flutter_test/flutter_test.dart';

DayModel _day(String id, int number) => DayModel(
  id: id,
  title: 'Day $number',
  difficulty: 'Beginner',
  durationMinutes: 6,
  netTimeMinutes: 5,
  caloriesBurned: 45,
  thumbnailUrl: '',
  exercises: const [],
);

ChallengeWeekModel _week(String id, int dayCount) => ChallengeWeekModel(
  id: id,
  title: 'Week ${id.split('_').last}',
  subtitle: 'Subtitle',
  currentDayIndex: 0,
  days: List.generate(dayCount, (i) => _day('${id}_d${i + 1}', i + 1)),
);

/// 3 weeks x 3 days — small enough to exercise every transition by hand.
ChallengeProgramModel _challenge() => ChallengeProgramModel(
  id: 'chal_test',
  titleLead: 'Test ',
  titleAccent: 'Challenge',
  title: 'Test Challenge',
  daysLabel: '9 Days',
  userCount: '1 User',
  thumbnailUrl: '',
  weeks: [_week('week_1', 3), _week('week_2', 3), _week('week_3', 3)],
);

void main() {
  late AppDatabase db;
  late ProgressRepository progress;

  setUp(() async {
    // rootBundle (challenges.json) needs the binding up.
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    await db.customSelect('SELECT 1').get();
    progress = ProgressRepository(db);
  });

  tearDown(() async => db.close());

  Future<void> completeDay(String weekId, int dayIndex, {int total = 3}) {
    return progress.recordSession(
      planId: 'chal_test/$weekId',
      planType: PlanType.challenge,
      planTitle: 'Test Challenge',
      dayId: '${weekId}_d${dayIndex + 1}',
      dayTitle: 'Day ${dayIndex + 1}',
      dayIndex: dayIndex,
      totalDays: total,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 60,
      startedAt: DateTime.now(),
    );
  }

  test('a fresh challenge only unlocks week 1, day 1', () async {
    final result = await ChallengeProgress.resolve(_challenge(), progress);

    expect(result.statusOf(0, 0), ChallengeDayStatus.current);
    expect(result.statusOf(0, 1), ChallengeDayStatus.locked);
    expect(result.statusOf(0, 2), ChallengeDayStatus.locked);
    expect(result.statusOf(1, 0), ChallengeDayStatus.locked, reason: 'week 2 needs week 1 done first');
    expect(result.isComplete, isFalse);
  });

  test('finishing a day unlocks the next one within the same week', () async {
    await completeDay('week_1', 0);

    final result = await ChallengeProgress.resolve(_challenge(), progress);
    expect(result.statusOf(0, 0), ChallengeDayStatus.completed);
    expect(result.statusOf(0, 1), ChallengeDayStatus.current);
    expect(result.statusOf(0, 2), ChallengeDayStatus.locked);
    expect(result.isDayUnlocked(0, 1), isTrue);
    expect(result.isDayUnlocked(0, 2), isFalse);
  });

  test('a week only unlocks once every prior day is done', () async {
    await completeDay('week_1', 0);
    await completeDay('week_1', 1);
    // Week 1 day 3 still outstanding.

    final result = await ChallengeProgress.resolve(_challenge(), progress);
    expect(result.isWeekUnlocked(1), isFalse);
    expect(result.statusOf(1, 0), ChallengeDayStatus.locked);

    await completeDay('week_1', 2);
    final afterFinishingWeek1 = await ChallengeProgress.resolve(
      _challenge(),
      progress,
    );
    expect(afterFinishingWeek1.isWeekUnlocked(1), isTrue);
    expect(afterFinishingWeek1.statusOf(1, 0), ChallengeDayStatus.current);
    expect(afterFinishingWeek1.currentPositionLabel, 'Week 2, Day 1');
  });

  test('replaying a completed day never re-locks anything', () async {
    await completeDay('week_1', 0);
    await completeDay('week_1', 1);
    await completeDay('week_1', 2);
    // Replay day 1 again.
    await completeDay('week_1', 0);

    final result = await ChallengeProgress.resolve(_challenge(), progress);
    expect(result.isWeekUnlocked(1), isTrue);
    expect(result.statusOf(0, 0), ChallengeDayStatus.completed);
  });

  test('a fully finished challenge reports complete and points at the last day', () async {
    for (final weekId in ['week_1', 'week_2', 'week_3']) {
      for (var i = 0; i < 3; i++) {
        await completeDay(weekId, i);
      }
    }

    final result = await ChallengeProgress.resolve(_challenge(), progress);
    expect(result.isComplete, isTrue);
    expect(result.statusOf(2, 2), ChallengeDayStatus.completed);
    expect(result.currentTarget!.weekIndex, 2);
    expect(result.currentTarget!.dayIndex, 2);
  });

  test('the Home banner rolls a finished week over into the next one', () async {
    // Real bundled content this time, not the fixture — end-to-end through
    // NextUpService, exercising the fix for the bug where a finished week's
    // currentDayIndex (7, past the last valid index) used to clamp back to
    // day 7 instead of rolling into week 2 day 1.
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere((c) => c.id == 'chal_flat_belly');
    final week1 = challenge.weeks.first;
    expect(week1.days.length, 7, reason: 'sanity check on the fixture data');

    for (var i = 0; i < week1.days.length; i++) {
      await progress.recordSession(
        planId: '${challenge.id}/${week1.id}',
        planType: PlanType.challenge,
        planTitle: challenge.title,
        dayId: week1.days[i].id,
        dayTitle: week1.days[i].title,
        dayIndex: i,
        totalDays: week1.days.length,
        exercisesCompleted: 1,
        exercisesTotal: 1,
        durationSeconds: 60,
        startedAt: DateTime.now(),
      );
    }

    final target = await NextUpService(progress).resolve();
    expect(target, isNotNull);
    expect(target!.challenge?.id, 'chal_flat_belly');
    expect(target.week?.id, challenge.weeks[1].id, reason: 'rolled into week 2');
    expect(target.suggestion.dayIndex, 0);
    expect(target.suggestion.dayTitle, challenge.weeks[1].days.first.title);
  });
}
