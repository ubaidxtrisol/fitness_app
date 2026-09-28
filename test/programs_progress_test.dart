import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/workout/models/phase_definitions.dart';
import 'package:fitness_app/features/workout/services/programs_progress.dart';
import 'package:flutter_test/flutter_test.dart';

WorkoutModel _day(String id) => WorkoutModel(
  id: id,
  title: id,
  difficulty: 'Beginner',
  durationMinutes: 3,
  netTimeMinutes: 5,
  caloriesBurned: 24,
  thumbnailUrl: '',
  exercises: const [],
);

/// One category with exactly Phase 1's 3 days authored (matching
/// `kPhaseDefinitions[0]`, days 1-3) and nothing beyond — the same shape
/// as the real bundled/network content today.
List<CategoryModel> _phaseOneOnly() => [
  CategoryModel(
    id: 'cat_test',
    title: 'Test Program',
    description: '',
    workouts: [_day('d1'), _day('d2'), _day('d3')],
  ),
];

void main() {
  late AppDatabase db;
  late ProgressRepository progress;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    await db.customSelect('SELECT 1').get();
    progress = ProgressRepository(db);
  });

  tearDown(() async => db.close());

  Future<void> completeDay(int flatIndex) => progress.recordSession(
    planId: phasesPlanId,
    planType: PlanType.program,
    planTitle: 'Phase 1',
    dayId: 'd$flatIndex',
    dayTitle: 'Day',
    dayIndex: flatIndex,
    totalDays: 3,
    exercisesCompleted: 1,
    exercisesTotal: 1,
    durationSeconds: 60,
    startedAt: DateTime.now(),
  );

  test('days bucket into the fixed phase ranges by absolute position', () async {
    final result = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(result.daysInPhase(0).length, 3, reason: 'phase 1 covers days 1-3');
    expect(result.daysInPhase(1), isEmpty, reason: 'nothing authored for phase 2 yet');
    expect(result.currentTarget!.phaseIndex, 0);
    expect(result.currentTarget!.dayIndex, 0);
  });

  test('an empty phase does not block the one after it', () async {
    // Phase 2 has no days loaded, so it can never itself be "finished" —
    // it must not stay permanently locked once phase 1 is done, or phase 3
    // could never unlock once real phase-2 content lands.
    final result = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(result.isPhaseUnlocked(1), isFalse, reason: 'phase 1 not done yet');

    for (var i = 0; i < 3; i++) {
      await completeDay(i);
    }
    final done = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(done.isPhaseUnlocked(1), isTrue, reason: 'phase 1 fully done');
    expect(done.isPhaseUnlocked(2), isTrue, reason: 'empty phase 2 does not block phase 3');
  });

  test('day statuses move from current to completed as days finish', () async {
    final fresh = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(fresh.statusOf(0, 0), ChallengeDayStatus.current);
    expect(fresh.statusOf(0, 1), ChallengeDayStatus.locked);

    await completeDay(0);
    final mid = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(mid.statusOf(0, 0), ChallengeDayStatus.completed);
    expect(mid.statusOf(0, 1), ChallengeDayStatus.current);
  });

  test('overall progress counts against the fixed 30-day program, not just what is loaded', () async {
    await completeDay(0);
    await completeDay(1);
    await completeDay(2);

    final result = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(result.overallDaysLabel, '3 of $kPhasesProgramTotalDays Days');
    expect(result.percentComplete, closeTo(3 / kPhasesProgramTotalDays, 0.001));
    expect(
      result.isComplete,
      isFalse,
      reason: 'only 3 of 30 days done, even though every loaded day is finished',
    );
  });

  test("a phase's own ring counts against its own day range, not the whole program", () async {
    await completeDay(0);
    final result = await ProgramsProgress.resolve(_phaseOneOnly(), progress);
    expect(
      result.percentForPhase(0),
      closeTo(1 / 3, 0.001),
      reason: 'phase 1 is a 3-day range and 1 of its days is done',
    );
    expect(result.percentForPhase(1), 0, reason: 'nothing loaded or done for phase 2');
  });
}
