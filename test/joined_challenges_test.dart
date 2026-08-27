import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/joined_challenges_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The "Join Challenge" button's persistence — a plain join-event log, never
/// mutated after the fact. Percent complete / finished are always recomputed
/// from `plan_progress_rows` via `ChallengeProgress`, not stored here.
void main() {
  late AppDatabase db;
  late JoinedChallengesRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    await db.customSelect('SELECT 1').get();
    repo = JoinedChallengesRepository(db);
  });

  tearDown(() async => db.close());

  test('a challenge nobody has joined reports as not joined', () async {
    expect(await repo.isJoined('chal_flat_belly'), isFalse);
    expect(await repo.find('chal_flat_belly'), isNull);
    expect(await repo.all(), isEmpty);
  });

  test('joining records the challenge', () async {
    await repo.join('chal_flat_belly');

    expect(await repo.isJoined('chal_flat_belly'), isTrue);
    final row = await repo.find('chal_flat_belly');
    expect(row, isNotNull);
    expect(row!.challengeId, 'chal_flat_belly');
  });

  test('joining twice does not duplicate or reset the original join', () async {
    await repo.join('chal_flat_belly');
    final first = await repo.find('chal_flat_belly');

    await repo.join('chal_flat_belly');
    final second = await repo.find('chal_flat_belly');

    expect(await repo.all(), hasLength(1));
    expect(second!.joinedAt, first!.joinedAt);
  });

  test('all() lists every joined challenge, most recently joined first', () async {
    await repo.join('chal_flat_belly', at: DateTime(2026, 1, 1));
    await repo.join('chal_wall_pilates', at: DateTime(2026, 1, 2));

    final all = await repo.all();
    expect(all.map((r) => r.challengeId).toList(), [
      'chal_wall_pilates',
      'chal_flat_belly',
    ]);
  });
}
