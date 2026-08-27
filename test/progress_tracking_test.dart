import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/core/database/repositories/settings_repository.dart';
import 'package:fitness_app/core/database/repositories/user_profile_repository.dart';
import 'package:fitness_app/features/home/services/next_up_service.dart';
import 'package:fitness_app/features/progress/widgets/history_month_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ProgressRepository progress;

  setUp(() async {
    // rootBundle (programs.json) needs the binding up.
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    // Force schema creation + seeding.
    await db.customSelect('SELECT 1').get();
    progress = ProgressRepository(db);
  });

  tearDown(() async => db.close());

  test('onboarding gate flips only when the flow finishes', () async {
    final profiles = UserProfileRepository(db);
    expect(await profiles.isOnboardingComplete(), isFalse);

    await profiles.saveAnswers({'age': 31, 'height': 170, 'weight': 64});
    expect(
      await profiles.isOnboardingComplete(),
      isFalse,
      reason: 'mid-flow saves must not unlock the app',
    );

    final mid = await profiles.load();
    expect(mid.age, 31);
    expect(mid.heightCm, 170);

    await profiles.saveAnswers({
      'workout_level': 'beginner',
    }, markComplete: true);
    expect(await profiles.isOnboardingComplete(), isTrue);
    expect(await profiles.difficultyLabel(), 'Beginner');
    // Earlier answers survive a later partial save.
    expect((await profiles.load()).age, 31);
  });

  test('settings round-trip and drive the player defaults', () async {
    final settings = SettingsRepository(db);
    final initial = await settings.load();
    expect(initial.countdownSeconds, 5);
    expect(initial.volume, closeTo(0.6, 0.001));

    await settings.update(countdownSeconds: 12, volume: 0.25);
    final updated = await settings.load();
    expect(updated.countdownSeconds, 12);
    expect(updated.volume, closeTo(0.25, 0.001));
    expect(updated.soundEffectEnabled, isTrue, reason: 'untouched stays put');
  });

  test('finishing a day advances the plan and feeds the banner', () async {
    final start = DateTime.now().subtract(const Duration(minutes: 6));

    await progress.recordSession(
      planId: 'prog_pilates_premier',
      planType: PlanType.program,
      planTitle: 'Pilates Premier',
      dayId: 'day_1',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 7,
      exercisesTotal: 7,
      durationSeconds: 360,
      startedAt: start,
    );

    final plan = await progress.planProgress('prog_pilates_premier');
    expect(plan, isNotNull);
    expect(plan!.currentDayIndex, 1, reason: 'a full day moves to the next');
    expect(plan.completedDays, 1);

    final summary = await progress.summaryForDay();
    expect(summary.workouts, 1);
    expect(summary.minutes, 6);
    expect(summary.calories, ProgressRepository.estimateCalories(360));
    expect(summary.streakDays, 1);
  });

  test('an abandoned day does not advance the plan', () async {
    await progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'P',
      dayId: 'd1',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 2,
      exercisesTotal: 7,
      durationSeconds: 60,
      startedAt: DateTime.now(),
    );
    final plan = await progress.planProgress('p1');
    expect(plan!.currentDayIndex, 0);
    expect(plan.completedDays, 0);
  });

  test('replaying an earlier day never rewinds progress', () async {
    for (var i = 0; i < 3; i++) {
      await progress.recordSession(
        planId: 'p1',
        planType: PlanType.program,
        planTitle: 'P',
        dayId: 'd$i',
        dayTitle: 'Day ${i + 1}',
        dayIndex: i,
        totalDays: 5,
        exercisesCompleted: 5,
        exercisesTotal: 5,
        durationSeconds: 300,
        startedAt: DateTime.now(),
      );
    }
    expect((await progress.planProgress('p1'))!.currentDayIndex, 3);

    // Redo day 1.
    await progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'P',
      dayId: 'd0',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 5,
      exercisesCompleted: 5,
      exercisesTotal: 5,
      durationSeconds: 300,
      startedAt: DateTime.now(),
    );
    expect(
      (await progress.planProgress('p1'))!.currentDayIndex,
      3,
      reason: 'must not go backwards',
    );
  });

  test('streak counts consecutive days and breaks on a gap', () async {
    final today = DateTime.now();
    Future<void> log(int daysAgo) => progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'P',
      dayId: 'd',
      dayTitle: 'Day',
      dayIndex: 0,
      totalDays: 1,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 120,
      startedAt: today.subtract(Duration(days: daysAgo)),
      completedAt: today.subtract(Duration(days: daysAgo)),
    );

    await log(0);
    await log(1);
    await log(2);
    expect(await progress.currentStreak(), 3);

    await log(5); // gap at days 3-4
    expect(await progress.currentStreak(), 3, reason: 'gap ends the streak');
  });

  test('weekly series buckets Monday-first', () async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    await progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'P',
      dayId: 'd',
      dayTitle: 'Day',
      dayIndex: 0,
      totalDays: 1,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 600,
      startedAt: monday,
      completedAt: monday.add(const Duration(hours: 9)),
    );

    final minutes = await progress.weeklySeries(minutes: true);
    expect(minutes.length, 7);
    expect(minutes[0], closeTo(10, 0.01), reason: 'Monday bucket');
    expect(minutes.sublist(1).every((v) => v == 0), isTrue);
  });

  test('the period pill changes which buckets the chart plots', () async {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1, 9);

    await progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'P',
      dayId: 'd',
      dayTitle: 'Day',
      dayIndex: 0,
      totalDays: 1,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 900,
      startedAt: firstOfMonth,
      completedAt: firstOfMonth,
    );

    final daysInMonth = DateTime(
      now.year,
      now.month + 1,
    ).difference(DateTime(now.year, now.month)).inDays;

    final month = await progress.chartSeries(
      ProgressPeriod.thisMonth,
      minutes: true,
    );
    expect(month.values.length, daysInMonth);
    expect(month.labels.length, daysInMonth);
    expect(month.values[0], closeTo(15, 0.01), reason: 'the 1st');
    expect(month.values.sublist(1).every((v) => v == 0), isTrue);
    expect(month.labels.first, '1');
    expect(
      month.labels[1],
      '',
      reason: 'a 31-bar axis only labels every fifth day',
    );

    final year = await progress.chartSeries(
      ProgressPeriod.thisYear,
      minutes: false,
    );
    expect(year.values.length, 12);
    // 15 active minutes at the 8 kcal/min estimate.
    expect(year.values[now.month - 1], closeTo(120, 0.01));
    expect(year.values.where((v) => v > 0).length, 1);
  });

  test('deleting a session drops it from history and the totals', () async {
    Future<void> log(DateTime at, int seconds) => progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'Pilates Premier',
      dayId: 'd${at.day}',
      dayTitle: 'Day ${at.day}',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: seconds,
      startedAt: at,
      completedAt: at,
    );

    await log(DateTime(2026, 8, 2, 7), 300);
    await log(DateTime(2026, 8, 12, 16), 600);

    final before = await progress.recentSessions();
    expect(before.length, 2);
    final newest = before.first;

    await progress.deleteSession(newest.id);

    final after = await progress.recentSessions();
    expect(after.length, 1);
    expect(after.single.id, isNot(newest.id));

    final summary = await progress.lifetimeSummary();
    expect(summary.workouts, 1);
    expect(summary.minutes, 5);

    final plan = await progress.planProgress('p1');
    expect(
      plan!.currentDayIndex,
      1,
      reason: 'deleting a log must not rewind the plan behind the banner',
    );
  });

  test('history groups into months, newest first', () async {
    Future<void> log(DateTime at) => progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'Pilates Premier',
      dayId: 'd${at.month}${at.day}',
      dayTitle: 'Day ${at.day}',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 300,
      startedAt: at,
      completedAt: at,
    );

    await log(DateTime(2026, 7, 4, 8));
    await log(DateTime(2026, 8, 2, 7));
    await log(DateTime(2026, 8, 12, 16, 13));

    final months = groupSessionsByMonth(await progress.recentSessions());

    expect(months.map((m) => m.key).toList(), ['August 2026', 'July 2026']);
    expect(months.first.value.length, 2);
    expect(
      months.first.value.first.completedAt.day,
      12,
      reason: 'newest first inside a month',
    );
  });

  test('a session carries the artwork and level its card renders', () async {
    await progress.recordSession(
      planId: 'p1',
      planType: PlanType.program,
      planTitle: 'Pilates Premier',
      dayId: 'd2',
      dayTitle: 'Day 2',
      dayLevel: 'Beginner',
      dayIndex: 1,
      totalDays: 3,
      exercisesCompleted: 7,
      exercisesTotal: 7,
      durationSeconds: 253,
      startedAt: DateTime(2026, 8, 12, 16, 9),
      completedAt: DateTime(2026, 8, 12, 16, 13),
      thumbnailUrl: 'https://cdn.example.com/pilates.jpg',
    );

    final log = (await progress.recentSessions()).single;
    expect(log.dayLevel, 'Beginner');
    expect(log.thumbnailUrl, 'https://cdn.example.com/pilates.jpg');
  });

  test('exercise logs accumulate per finished exercise', () async {
    await progress.recordExercise(
      exerciseId: 'ex_a',
      title: 'Dynamic Chest',
      durationSeconds: 35,
    );
    await progress.recordExercise(
      exerciseId: 'ex_b',
      title: 'Toros Twist',
      durationSeconds: 35,
    );
    expect(await progress.totalExercisesCompleted(), 2);
  });

  test('next-up offers day 1 before any history', () async {
    final target = await NextUpService(progress).resolve();
    expect(target, isNotNull, reason: 'programs.json should resolve');
    expect(target!.suggestion.dayTitle, 'Day 1');
    expect(target.suggestion.isResuming, isFalse);
    expect(target.suggestion.metaLabel, '5min/7 Exercise');
    expect(target.suggestion.planTitle, 'Pilates Premier');
  });

  test('next-up rolls to day 2 once day 1 is finished', () async {
    await progress.recordSession(
      planId: 'prog_pilates_premier',
      planType: PlanType.program,
      planTitle: 'Pilates Premier',
      dayId: 'day_1',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 7,
      exercisesTotal: 7,
      durationSeconds: 360,
      startedAt: DateTime.now(),
    );

    final target = await NextUpService(progress).resolve();
    expect(target!.suggestion.dayTitle, 'Day 2');
    expect(target.suggestion.isResuming, isTrue);
    expect(target.suggestion.metaLabel, '6min/8 Exercise');
    expect(target.suggestion.dayIndex, 1);
    expect(target.day, isNotNull, reason: 'banner needs the day to push');
    expect(target.phase, isNotNull);
  });

  test('most recent plan is what the banner resumes', () async {
    await progress.recordSession(
      planId: 'older',
      planType: PlanType.program,
      planTitle: 'Older',
      dayId: 'd',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 3,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 60,
      startedAt: DateTime.now(),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    );
    await progress.recordSession(
      planId: 'newer',
      planType: PlanType.challenge,
      planTitle: 'Newer',
      dayId: 'd',
      dayTitle: 'Day 1',
      dayIndex: 0,
      totalDays: 7,
      exercisesCompleted: 1,
      exercisesTotal: 1,
      durationSeconds: 60,
      startedAt: DateTime.now(),
      completedAt: DateTime.now(),
    );
    expect((await progress.mostRecentPlan())!.planId, 'newer');
  });
}
