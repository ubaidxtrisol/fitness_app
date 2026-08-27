import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';

part 'app_database.g.dart';

/// Which flow a logged workout came from.
class PlanType {
  static const String program = 'program';
  static const String challenge = 'challenge';
  static const String bodyFocus = 'body_focus';
  static const String discover = 'discover';
}

/// The answers collected by the user info flow. Single row, id == 1.
class UserProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get goal => text().withDefault(const Constant('lose_weight'))();
  TextColumn get gender => text().withDefault(const Constant('female'))();
  IntColumn get age => integer().withDefault(const Constant(28))();
  IntColumn get heightCm => integer().withDefault(const Constant(165))();
  IntColumn get weightKg => integer().withDefault(const Constant(75))();
  IntColumn get targetWeightKg => integer().withDefault(const Constant(70))();
  TextColumn get currentBodyShape =>
      text().withDefault(const Constant('average'))();
  TextColumn get targetBodyShape => text().withDefault(const Constant('lean'))();
  TextColumn get workoutPlace => text().withDefault(const Constant('home'))();
  TextColumn get workoutLevel =>
      text().withDefault(const Constant('intermediate'))();
  TextColumn get bellyHipType =>
      text().withDefault(const Constant('hourglass'))();
  TextColumn get legType => text().withDefault(const Constant('normal'))();

  /// JSON-encoded lists so the multi-select answers survive round-trips.
  TextColumn get activitiesJson => text().withDefault(const Constant('[]'))();
  TextColumn get injuriesJson => text().withDefault(const Constant('[]'))();

  /// Set once the flow is finished — the splash screen gates on this.
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Everything the workout settings screen controls. Single row, id == 1.
class WorkoutSettingsRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get voiceGuideEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get detailedGuide => boolean().withDefault(const Constant(true))();
  RealColumn get volume => real().withDefault(const Constant(0.6))();
  BoolColumn get soundEffectEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get countdownSeconds => integer().withDefault(const Constant(5))();

  @override
  Set<Column> get primaryKey => {id};
}

/// How far the user is through a given plan. One row per plan.
class PlanProgressRows extends Table {
  TextColumn get planId => text()();
  TextColumn get planType => text()();
  TextColumn get planTitle => text()();

  /// Index of the next day to do, 0-based.
  IntColumn get currentDayIndex => integer().withDefault(const Constant(0))();
  IntColumn get totalDays => integer().withDefault(const Constant(0))();
  IntColumn get completedDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get lastActivityAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {planId};
}

/// One finished (or abandoned) run through a day/session.
class SessionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get planId => text()();
  TextColumn get planType => text()();
  TextColumn get planTitle => text()();
  TextColumn get dayId => text()();
  TextColumn get dayTitle => text()();

  /// "Beginner" / "Intermediate" — the second half of the history card's
  /// "Day 2. Beginner" line (Figma 17:1633).
  TextColumn get dayLevel => text().withDefault(const Constant(''))();
  IntColumn get dayIndex => integer().withDefault(const Constant(0))();
  IntColumn get exercisesCompleted => integer().withDefault(const Constant(0))();
  IntColumn get exercisesTotal => integer().withDefault(const Constant(0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  /// Artwork for the history card's tile (Figma 17:1631) — the thumbnail of
  /// the first exercise in the run, captured at log time so history keeps
  /// showing what the user actually did even if the catalogue changes.
  TextColumn get thumbnailUrl => text().withDefault(const Constant(''))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();
}

/// One exercise the user actually finished, tied to its session.
class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionLogId => integer().nullable()();
  TextColumn get exerciseId => text()();
  TextColumn get title => text()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get calories => integer().withDefault(const Constant(0))();
  TextColumn get thumbnailUrl => text().withDefault(const Constant(''))();
  DateTimeColumn get completedAt => dateTime()();
}

/// The duration the user dialled in for one exercise on the detail screen's
/// stepper (Figma 11:1104).
///
/// Absent until the stepper is touched, so an untouched exercise keeps running
/// for its clip's natural length.
class ExercisePreferences extends Table {
  TextColumn get exerciseId => text()();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {exerciseId};
}

/// A run through a day that has started but not yet finished — the
/// resumable checkpoint behind "continue where you left off".
///
/// Written incrementally as each exercise finishes (not just at the end), so
/// it survives the app being killed mid-workout. Cleared once the day is
/// finished or explicitly abandoned via "Do it Later"/"Restart".
class ActiveSessions extends Table {
  TextColumn get planId => text()();
  TextColumn get dayId => text()();
  TextColumn get planType => text()();
  TextColumn get planTitle => text()();
  TextColumn get dayTitle => text()();
  TextColumn get dayLevel => text().withDefault(const Constant(''))();
  IntColumn get dayIndex => integer().withDefault(const Constant(0))();
  IntColumn get totalDays => integer().withDefault(const Constant(0))();

  /// JSON-encoded list of `"exerciseId#index"` keys — the same dedup key the
  /// player already uses, so resuming can't double-log an exercise.
  TextColumn get completedExerciseIdsJson =>
      text().withDefault(const Constant('[]'))();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {planId, dayId};
}

/// A challenge the user has explicitly joined — Requirement: a "Join"
/// button on the challenge detail screen (and the quick-join pill on its
/// card) that starts tracking that specific challenge for the Home banner
/// and the joined-challenges priority ordering.
///
/// Deliberately holds only the join event. Whether a joined challenge is
/// complete, and how far through it the user is, is always recomputed from
/// `plan_progress_rows` via `ChallengeProgress` rather than duplicated here
/// — see the known-bugs note in docs/context.md about not persisting a
/// number that can drift out of sync with the real per-day progress.
class JoinedChallenges extends Table {
  TextColumn get challengeId => text()();
  DateTimeColumn get joinedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {challengeId};
}

@DriftDatabase(
  tables: [
    UserProfiles,
    WorkoutSettingsRows,
    PlanProgressRows,
    SessionLogs,
    ExerciseLogs,
    ExercisePreferences,
    ActiveSessions,
    JoinedChallenges,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  /// Test constructor — pass an in-memory or mock executor.
  AppDatabase.forTesting(super.executor);

  static AppDatabase? _instance;

  static AppDatabase get instance => _instance ??= AppDatabase._();

  /// Replaces the singleton; used by tests.
  static void overrideInstance(AppDatabase database) => _instance = database;

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      // v2 — history cards render the exercise artwork instead of a grey tile.
      if (from < 2) {
        await m.addColumn(sessionLogs, sessionLogs.thumbnailUrl);
        await m.addColumn(sessionLogs, sessionLogs.dayLevel);
        await m.addColumn(exerciseLogs, exerciseLogs.thumbnailUrl);
      }
      // v3 — the detail screen's stepper remembers a per-exercise duration.
      if (from < 3) {
        await m.createTable(exercisePreferences);
      }
      // v4 — mid-workout progress is checkpointed so it survives the app
      // being closed and can be resumed.
      if (from < 4) {
        await m.createTable(activeSessions);
      }
      // v5 — "Join Challenge" persists which challenges the user has opted
      // into tracking.
      if (from < 5) {
        await m.createTable(joinedChallenges);
      }
    },
    onCreate: (m) async {
      await m.createAll();
      // Seed the two single-row tables so reads never come back empty.
      await into(userProfiles).insert(
        UserProfilesCompanion.insert(
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
        mode: InsertMode.insertOrIgnore,
      );
      await into(workoutSettingsRows).insert(
        const WorkoutSettingsRowsCompanion(),
        mode: InsertMode.insertOrIgnore,
      );
    },
  );
}

QueryExecutor _openConnection() {
  return SqfliteQueryExecutor.inDatabaseFolder(path: 'fitness_app.sqlite');
}
