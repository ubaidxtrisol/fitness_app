import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/core/database/repositories/joined_challenges_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
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

  test('percentComplete and hasProgress track total days across every week', () async {
    final fresh = await ChallengeProgress.resolve(_challenge(), progress);
    expect(fresh.totalDays, 9);
    expect(fresh.totalCompletedDays, 0);
    expect(fresh.percentComplete, 0);
    expect(fresh.hasProgress, isFalse);

    await completeDay('week_1', 0);
    await completeDay('week_1', 1);
    await completeDay('week_1', 2);

    final afterWeek1 = await ChallengeProgress.resolve(_challenge(), progress);
    expect(afterWeek1.totalCompletedDays, 3);
    expect(afterWeek1.percentComplete, closeTo(3 / 9, 0.0001));
    expect(afterWeek1.hasProgress, isTrue);
  });

  test('a fully finished challenge reports 100% complete', () async {
    for (final weekId in ['week_1', 'week_2', 'week_3']) {
      for (var i = 0; i < 3; i++) {
        await completeDay(weekId, i);
      }
    }

    final result = await ChallengeProgress.resolve(_challenge(), progress);
    expect(result.percentComplete, 1.0);
  });

  test(
    'a joined challenge with no logged day yet still surfaces on the Home banner',
    () async {
      // Real bundled content, exercising the fallback tier between "most
      // recently touched plan" and "first bundled program day": joining a
      // challenge should show up on Home right away, before anything is
      // logged against it.
      final joined = JoinedChallengesRepository(db);
      final challenges = await ChallengeRepository.loadChallenges();
      final challenge = challenges.firstWhere((c) => c.id == 'chal_flat_belly');

      await joined.join(challenge.id);

      final target = await NextUpService(progress, joined).resolve();
      expect(target, isNotNull);
      expect(target!.challenge?.id, 'chal_flat_belly');
      expect(target.week?.id, challenge.weeks.first.id);
      expect(target.suggestion.dayIndex, 0);
      expect(target.suggestion.isResuming, isFalse);
    },
  );

  test(
    'a plan already in progress still wins over a freshly joined challenge',
    () async {
      final challenges = await ChallengeRepository.loadChallenges();
      final flatBelly = challenges.firstWhere(
        (c) => c.id == 'chal_flat_belly',
      );
      final wallPilates = challenges.firstWhere(
        (c) => c.id == 'chal_wall_pilates',
      );

      final joined = JoinedChallengesRepository(db);
      await joined.join(flatBelly.id);

      // The user is actually mid-way through a different (real, resolvable)
      // challenge — that must still win the hero-banner slot.
      final week1 = wallPilates.weeks.first;
      await progress.recordSession(
        planId: '${wallPilates.id}/${week1.id}',
        planType: PlanType.challenge,
        planTitle: wallPilates.title,
        dayId: week1.days.first.id,
        dayTitle: week1.days.first.title,
        dayIndex: 0,
        totalDays: week1.days.length,
        exercisesCompleted: 1,
        exercisesTotal: 1,
        durationSeconds: 60,
        startedAt: DateTime.now(),
      );

      final target = await NextUpService(progress, joined).resolve();
      expect(target, isNotNull);
      expect(
        target!.challenge?.id,
        'chal_wall_pilates',
        reason: 'most recently touched plan still wins',
      );
    },
  );

  test(
    'a finished joined challenge is skipped in favour of one still going',
    () async {
      final challenges = await ChallengeRepository.loadChallenges();
      final finished = challenges.firstWhere((c) => c.id == 'chal_flat_belly');
      final stillGoing = challenges.firstWhere(
        (c) => c.id == 'chal_wall_pilates',
      );

      final joined = JoinedChallengesRepository(db);
      // Joined in this order so `finished` (joined more recently) is
      // iterated first — the fallback must skip it, not just happen to
      // reach `stillGoing` because it was tried first.
      await joined.join(stillGoing.id, at: DateTime(2026, 1, 1));
      await joined.join(finished.id, at: DateTime(2026, 1, 2));

      // Every `completedAt` is explicit and strictly increasing — the
      // dateTime column stores with one-second resolution, too coarse to
      // trust real `DateTime.now()` calls made this close together to land
      // in the right order.
      var clock = DateTime(2026, 2, 1);
      DateTime tick() => clock = clock.add(const Duration(days: 1));

      for (final week in finished.weeks) {
        for (var i = 0; i < week.days.length; i++) {
          await progress.recordSession(
            planId: '${finished.id}/${week.id}',
            planType: PlanType.challenge,
            planTitle: finished.title,
            dayId: week.days[i].id,
            dayTitle: week.days[i].title,
            dayIndex: i,
            totalDays: week.days.length,
            exercisesCompleted: 1,
            exercisesTotal: 1,
            durationSeconds: 60,
            startedAt: tick(),
            completedAt: clock,
          );
        }
      }

      // The most recently touched plan is now `finished` itself, which would
      // normally win outright via `mostRecentPlan()` — simulate it having
      // since vanished from the content (e.g. removed from the JSON), the
      // one realistic way `resolve()` actually reaches the joined-challenge
      // fallback despite a more recent row existing, so this test can prove
      // the fallback's own skip-if-complete line rather than tier one.
      await progress.recordSession(
        planId: 'prog_removed',
        planType: PlanType.program,
        planTitle: 'Removed Program',
        dayId: 'day_1',
        dayTitle: 'Day 1',
        dayIndex: 0,
        totalDays: 1,
        exercisesCompleted: 1,
        exercisesTotal: 1,
        durationSeconds: 60,
        startedAt: tick(),
        completedAt: clock,
      );

      final target = await NextUpService(progress, joined).resolve();
      expect(target, isNotNull);
      expect(
        target!.challenge?.id,
        'chal_wall_pilates',
        reason: 'the finished challenge must be skipped for the one still going',
      );
    },
  );

  test(
    'percentComplete gives partial credit for a day still mid-checkpoint',
    () async {
      final exercise = ExerciseModel(
        order: 1,
        exerciseId: 'ex_a',
        title: 'Glute Bridge',
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
      DayModel dayWithExercises(String id, {required int exerciseCount}) =>
          DayModel(
            id: id,
            title: 'Day $id',
            difficulty: 'Beginner',
            durationMinutes: 6,
            netTimeMinutes: 5,
            caloriesBurned: 45,
            thumbnailUrl: '',
            exercises: List.filled(exerciseCount, exercise),
          );

      // Four days total, only the first with real exercises — the checkpoint
      // sits on that first day so its fraction is the only credit at stake.
      final day1 = dayWithExercises('d1', exerciseCount: 4);
      final week = ChallengeWeekModel(
        id: 'week_1',
        title: 'Week 1',
        subtitle: 'Subtitle',
        currentDayIndex: 0,
        days: [
          day1,
          dayWithExercises('d2', exerciseCount: 0),
          dayWithExercises('d3', exerciseCount: 0),
          dayWithExercises('d4', exerciseCount: 0),
        ],
      );
      final challenge = ChallengeProgramModel(
        id: 'chal_partial',
        titleLead: 'Test ',
        titleAccent: 'Challenge',
        title: 'Test Challenge',
        daysLabel: '4 Days',
        userCount: '1 User',
        thumbnailUrl: '',
        weeks: [week],
      );

      final noCheckpoint = await ChallengeProgress.resolve(challenge, progress);
      expect(
        noCheckpoint.percentComplete,
        0,
        reason: 'nothing logged yet — no credit',
      );

      // 2 of day 1's 4 exercises finished, day itself not yet complete.
      await ActiveSessionRepository(db).save(
        planId: 'chal_partial/week_1',
        dayId: 'd1',
        planType: PlanType.challenge,
        planTitle: challenge.title,
        dayTitle: day1.title,
        completedExerciseIds: ['ex_a#0', 'ex_a#1'],
        elapsedSeconds: 70,
        startedAt: DateTime(2026, 1, 1),
      );

      final withCheckpoint = await ChallengeProgress.resolve(
        challenge,
        progress,
      );
      expect(
        withCheckpoint.totalCompletedDays,
        0,
        reason: 'the day itself is not logged as complete yet',
      );
      expect(
        withCheckpoint.percentComplete,
        closeTo(0.5 / 4, 0.0001),
        reason: '2 of 4 exercises on the only day of a 4-day challenge',
      );
    },
  );
}
