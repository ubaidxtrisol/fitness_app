import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// Tracks which challenges the user has explicitly joined.
///
/// This is the "Join Challenge" button's persistence: tapping it is the only
/// thing that writes here. Everything else about a joined challenge —
/// percent complete, whether it's finished, which day is next — is always
/// recomputed on the fly from `plan_progress_rows` via `ChallengeProgress`,
/// never duplicated into this table.
class JoinedChallengesRepository {
  final AppDatabase _db;

  JoinedChallengesRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  /// Records the join. A no-op if already joined, so a repeat tap (or the
  /// silent back-fill for challenges started before this existed) never
  /// resets `joinedAt`. [at] is for tests — the dateTime column is stored
  /// with one-second resolution, too coarse to order two real `DateTime.now()`
  /// calls a few milliseconds apart.
  Future<void> join(String challengeId, {DateTime? at}) async {
    final existing = await find(challengeId);
    if (existing != null) return;

    await _db
        .into(_db.joinedChallenges)
        .insert(
          JoinedChallengesCompanion.insert(
            challengeId: challengeId,
            joinedAt: at ?? DateTime.now(),
          ),
        );
  }

  Future<JoinedChallenge?> find(String challengeId) {
    return (_db.select(
      _db.joinedChallenges,
    )..where((t) => t.challengeId.equals(challengeId))).getSingleOrNull();
  }

  Future<bool> isJoined(String challengeId) async =>
      await find(challengeId) != null;

  /// Every joined challenge, most recently joined first.
  Future<List<JoinedChallenge>> all() {
    return (_db.select(_db.joinedChallenges)
          ..orderBy([
            (t) => OrderingTerm(expression: t.joinedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }
}
