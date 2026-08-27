import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The resumable checkpoint behind "continue where you left off" — saved
/// incrementally as each exercise finishes, so it survives the app being
/// closed mid-workout.
void main() {
  late AppDatabase db;
  late ActiveSessionRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    await db.customSelect('SELECT 1').get();
    repo = ActiveSessionRepository(db);
  });

  tearDown(() async => db.close());

  test('a day with no checkpoint has nothing to resume', () async {
    expect(await repo.find('prog_1', 'day_1'), isNull);
  });

  test('a checkpoint round-trips everything the player needs to resume', () async {
    final startedAt = DateTime(2026, 8, 12, 16, 9);

    await repo.save(
      planId: 'prog_1',
      dayId: 'day_2',
      planType: 'program',
      planTitle: 'Pilates Premier',
      dayTitle: 'Day 2',
      dayLevel: 'Beginner',
      dayIndex: 1,
      totalDays: 3,
      completedExerciseIds: ['ex_a#0', 'ex_b#1', 'ex_c#2', 'ex_d#3'],
      elapsedSeconds: 130,
      startedAt: startedAt,
    );

    final saved = await repo.find('prog_1', 'day_2');
    expect(saved, isNotNull);
    expect(saved!.planTitle, 'Pilates Premier');
    expect(saved.dayLevel, 'Beginner');
    expect(saved.elapsedSeconds, 130);
    expect(saved.startedAt, startedAt);

    final ids = repo.decodeCompletedIds(saved.completedExerciseIdsJson);
    expect(ids, ['ex_a#0', 'ex_b#1', 'ex_c#2', 'ex_d#3']);
  });

  test('saving again for the same day updates it instead of duplicating', () async {
    Future<void> saveAt(int elapsed, List<String> ids) => repo.save(
      planId: 'prog_1',
      dayId: 'day_2',
      planType: 'program',
      planTitle: 'Pilates Premier',
      dayTitle: 'Day 2',
      completedExerciseIds: ids,
      elapsedSeconds: elapsed,
      startedAt: DateTime(2026, 8, 12),
    );

    await saveAt(40, ['ex_a#0']);
    await saveAt(90, ['ex_a#0', 'ex_b#1']);

    final saved = await repo.find('prog_1', 'day_2');
    expect(saved!.elapsedSeconds, 90);
    expect(repo.decodeCompletedIds(saved.completedExerciseIdsJson).length, 2);
  });

  test('two different days on the same plan checkpoint independently', () async {
    Future<void> saveDay(String dayId) => repo.save(
      planId: 'chal_1/week_1',
      dayId: dayId,
      planType: 'challenge',
      planTitle: 'Flat Belly',
      dayTitle: dayId,
      completedExerciseIds: ['ex_a#0'],
      elapsedSeconds: 30,
      startedAt: DateTime(2026, 8, 12),
    );

    await saveDay('day_1');
    await saveDay('day_2');

    expect(await repo.find('chal_1/week_1', 'day_1'), isNotNull);
    expect(await repo.find('chal_1/week_1', 'day_2'), isNotNull);

    await repo.clear('chal_1/week_1', 'day_1');
    expect(await repo.find('chal_1/week_1', 'day_1'), isNull);
    expect(
      await repo.find('chal_1/week_1', 'day_2'),
      isNotNull,
      reason: 'clearing one day must not touch the other',
    );
  });

  test('malformed JSON decodes to an empty list rather than throwing', () {
    expect(repo.decodeCompletedIds('not json'), isEmpty);
    expect(repo.decodeCompletedIds('{}'), isEmpty);
    expect(repo.decodeCompletedIds('[]'), isEmpty);
  });
}
