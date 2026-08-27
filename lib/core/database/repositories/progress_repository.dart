import 'package:drift/drift.dart';
import 'package:fitness_app/core/database/app_database.dart';

/// Aggregate numbers for the Home summary and the Progress screen.
class ProgressSummary {
  final int calories;
  final int minutes;
  final int workouts;
  final int streakDays;

  const ProgressSummary({
    required this.calories,
    required this.minutes,
    required this.workouts,
    required this.streakDays,
  });

  static const empty = ProgressSummary(
    calories: 0,
    minutes: 0,
    workouts: 0,
    streakDays: 0,
  );
}

/// The ranges the Progress chart's period pill (Figma 16:1099) can show.
enum ProgressPeriod {
  thisWeek('This Week'),
  thisMonth('This Month'),
  thisYear('This Year');

  final String label;

  const ProgressPeriod(this.label);
}

/// One chart's worth of bars — a value per bucket and the x-axis label under
/// it. Labels are blank where the axis would otherwise crowd (a 31-day month
/// only labels every fifth day).
class ChartSeries {
  final List<double> values;
  final List<String> labels;

  const ChartSeries({required this.values, required this.labels});

  static const empty = ChartSeries(values: [], labels: []);

  bool get isEmpty => values.isEmpty;

  double get peak =>
      values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b);
}

/// What the Home hero banner should offer next.
class NextUpSuggestion {
  final String planId;
  final String planType;
  final String planTitle;
  final String dayTitle;
  final int dayIndex;
  final int totalDays;
  final int exerciseCount;
  final int durationMinutes;

  /// False when nothing has been logged yet, so the banner can say "start"
  /// rather than "continue".
  final bool isResuming;

  const NextUpSuggestion({
    required this.planId,
    required this.planType,
    required this.planTitle,
    required this.dayTitle,
    required this.dayIndex,
    required this.totalDays,
    required this.exerciseCount,
    required this.durationMinutes,
    required this.isResuming,
  });

  /// "6min/7 Exercise" — the banner's meta line.
  String get metaLabel => '${durationMinutes}min/$exerciseCount Exercise';
}

/// Records what the user actually did and answers the questions the UI asks
/// about it.
class ProgressRepository {
  final AppDatabase _db;

  ProgressRepository([AppDatabase? db]) : _db = db ?? AppDatabase.instance;

  // ---------------------------------------------------------------- writing

  /// Logs one finished exercise. Called by the player as each one ends, so a
  /// part-finished session still leaves a trail.
  Future<int> recordExercise({
    required String exerciseId,
    required String title,
    required int durationSeconds,
    String thumbnailUrl = '',
    int? sessionLogId,
    DateTime? completedAt,
  }) {
    return _db
        .into(_db.exerciseLogs)
        .insert(
          ExerciseLogsCompanion.insert(
            sessionLogId: Value(sessionLogId),
            exerciseId: exerciseId,
            title: title,
            durationSeconds: Value(durationSeconds),
            calories: Value(estimateCalories(durationSeconds)),
            thumbnailUrl: Value(thumbnailUrl),
            completedAt: completedAt ?? DateTime.now(),
          ),
        );
  }

  /// Logs a run through a day and advances that plan's progress.
  Future<int> recordSession({
    required String planId,
    required String planType,
    required String planTitle,
    required String dayId,
    required String dayTitle,
    required int dayIndex,
    String dayLevel = '',
    required int exercisesCompleted,
    required int exercisesTotal,
    required int durationSeconds,
    required DateTime startedAt,
    String thumbnailUrl = '',
    int totalDays = 0,
    DateTime? completedAt,
  }) async {
    final finishedAt = completedAt ?? DateTime.now();
    final completed =
        exercisesTotal > 0 && exercisesCompleted >= exercisesTotal;

    final sessionId = await _db
        .into(_db.sessionLogs)
        .insert(
          SessionLogsCompanion.insert(
            planId: planId,
            planType: planType,
            planTitle: planTitle,
            dayId: dayId,
            dayTitle: dayTitle,
            dayLevel: Value(dayLevel),
            dayIndex: Value(dayIndex),
            exercisesCompleted: Value(exercisesCompleted),
            exercisesTotal: Value(exercisesTotal),
            durationSeconds: Value(durationSeconds),
            calories: Value(estimateCalories(durationSeconds)),
            completed: Value(completed),
            thumbnailUrl: Value(thumbnailUrl),
            startedAt: startedAt,
            completedAt: finishedAt,
          ),
        );

    await _advancePlan(
      planId: planId,
      planType: planType,
      planTitle: planTitle,
      dayIndex: dayIndex,
      totalDays: totalDays,
      completed: completed,
      at: finishedAt,
    );

    return sessionId;
  }

  /// A deliberately simple estimate — roughly 8 kcal per active minute.
  /// Swap for a MET-based formula once weight and intensity are trusted.
  static int estimateCalories(int durationSeconds) =>
      (durationSeconds / 60 * 8).round();

  Future<void> _advancePlan({
    required String planId,
    required String planType,
    required String planTitle,
    required int dayIndex,
    required int totalDays,
    required bool completed,
    required DateTime at,
  }) async {
    final existing = await (_db.select(
      _db.planProgressRows,
    )..where((t) => t.planId.equals(planId))).getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.planProgressRows)
          .insert(
            PlanProgressRowsCompanion.insert(
              planId: planId,
              planType: planType,
              planTitle: planTitle,
              currentDayIndex: Value(completed ? dayIndex + 1 : dayIndex),
              totalDays: Value(totalDays),
              completedDays: Value(completed ? 1 : 0),
              startedAt: Value(at),
              lastActivityAt: Value(at),
            ),
          );
      return;
    }

    // Only move forward — replaying an earlier day must not rewind progress.
    final nextIndex = completed
        ? (dayIndex + 1 > existing.currentDayIndex
              ? dayIndex + 1
              : existing.currentDayIndex)
        : existing.currentDayIndex;

    await (_db.update(
      _db.planProgressRows,
    )..where((t) => t.planId.equals(planId))).write(
      PlanProgressRowsCompanion(
        currentDayIndex: Value(nextIndex),
        completedDays: Value(
          completed ? existing.completedDays + 1 : existing.completedDays,
        ),
        totalDays: totalDays > 0
            ? Value(totalDays)
            : Value(existing.totalDays),
        lastActivityAt: Value(at),
      ),
    );
  }

  // ---------------------------------------------------------------- reading

  Future<PlanProgressRow?> planProgress(String planId) {
    return (_db.select(
      _db.planProgressRows,
    )..where((t) => t.planId.equals(planId))).getSingleOrNull();
  }

  /// The plan the user touched most recently, if any.
  Future<PlanProgressRow?> mostRecentPlan() {
    return (_db.select(_db.planProgressRows)
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.lastActivityAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<SessionLog>> recentSessions({int limit = 20}) {
    return (_db.select(_db.sessionLogs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Stream<List<SessionLog>> watchRecentSessions({int limit = 20}) {
    return (_db.select(_db.sessionLogs)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  Future<List<SessionLog>> sessionsBetween(DateTime from, DateTime to) {
    return (_db.select(_db.sessionLogs)..where(
          (t) =>
              t.completedAt.isBiggerOrEqualValue(from) &
              t.completedAt.isSmallerThanValue(to),
        ))
        .get();
  }

  /// Totals for a single calendar day (defaults to today).
  Future<ProgressSummary> summaryForDay([DateTime? day]) async {
    final date = day ?? DateTime.now();
    final start = DateTime(date.year, date.month, date.day);
    final sessions = await sessionsBetween(
      start,
      start.add(const Duration(days: 1)),
    );

    return ProgressSummary(
      calories: sessions.fold(0, (sum, s) => sum + s.calories),
      minutes: sessions.fold(0, (sum, s) => sum + s.durationSeconds) ~/ 60,
      workouts: sessions.length,
      streakDays: await currentStreak(),
    );
  }

  Stream<ProgressSummary> watchTodaySummary() {
    return _db
        .select(_db.sessionLogs)
        .watch()
        .asyncMap((_) => summaryForDay());
  }

  /// All-time totals plus the streak, for the Progress screen header.
  Future<ProgressSummary> lifetimeSummary() async {
    final sessions = await _db.select(_db.sessionLogs).get();
    return ProgressSummary(
      calories: sessions.fold(0, (sum, s) => sum + s.calories),
      minutes: sessions.fold(0, (sum, s) => sum + s.durationSeconds) ~/ 60,
      workouts: sessions.length,
      streakDays: await currentStreak(),
    );
  }

  /// Consecutive days ending today (or yesterday, if today is still empty)
  /// that have at least one session.
  Future<int> currentStreak() async {
    final sessions = await _db.select(_db.sessionLogs).get();
    if (sessions.isEmpty) return 0;

    final days = sessions
        .map(
          (s) => DateTime(
            s.completedAt.year,
            s.completedAt.month,
            s.completedAt.day,
          ),
        )
        .toSet();

    final today = DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);

    // A streak stays alive until the day after the last workout has passed.
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
      if (!days.contains(cursor)) return 0;
    }

    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Seven buckets, Monday-first, for the Progress chart.
  /// [minutes] switches between duration and calories.
  Future<List<double>> weeklySeries({required bool minutes}) async {
    final series = await chartSeries(ProgressPeriod.thisWeek, minutes: minutes);
    return series.values;
  }

  static const List<String> _weekdayInitials = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  static const List<String> _monthInitials = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];

  /// The bars behind the Progress chart for a given [period].
  ///
  /// Week buckets by weekday (Monday first), month by day-of-month and year by
  /// calendar month, so the period pill actually changes what is plotted.
  /// [minutes] switches between duration and calories.
  Future<ChartSeries> chartSeries(
    ProgressPeriod period, {
    required bool minutes,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();

    switch (period) {
      case ProgressPeriod.thisWeek:
        final day = DateTime(today.year, today.month, today.day);
        final monday = day.subtract(Duration(days: day.weekday - 1));
        final values = await _bucket(
          from: monday,
          to: monday.add(const Duration(days: 7)),
          buckets: 7,
          minutes: minutes,
          indexOf: (at) => at.difference(monday).inDays,
        );
        return ChartSeries(values: values, labels: _weekdayInitials);

      case ProgressPeriod.thisMonth:
        final first = DateTime(today.year, today.month);
        final next = DateTime(today.year, today.month + 1);
        final days = next.difference(first).inDays;
        final values = await _bucket(
          from: first,
          to: next,
          buckets: days,
          minutes: minutes,
          indexOf: (at) => at.day - 1,
        );
        // A 31-bar axis only has room for a label every fifth day.
        final labels = List<String>.generate(
          days,
          (i) => i == 0 || (i + 1) % 5 == 0 ? '${i + 1}' : '',
        );
        return ChartSeries(values: values, labels: labels);

      case ProgressPeriod.thisYear:
        final first = DateTime(today.year);
        final values = await _bucket(
          from: first,
          to: DateTime(today.year + 1),
          buckets: 12,
          minutes: minutes,
          indexOf: (at) => at.month - 1,
        );
        return ChartSeries(values: values, labels: _monthInitials);
    }
  }

  Future<List<double>> _bucket({
    required DateTime from,
    required DateTime to,
    required int buckets,
    required bool minutes,
    required int Function(DateTime) indexOf,
  }) async {
    final sessions = await sessionsBetween(from, to);
    final values = List<double>.filled(buckets, 0);

    for (final session in sessions) {
      final index = indexOf(session.completedAt);
      if (index < 0 || index >= buckets) continue;
      values[index] += minutes
          ? session.durationSeconds / 60
          : session.calories.toDouble();
    }
    return values;
  }

  /// Removes one logged session and the exercises filed under it — the trash
  /// button on the history card (Figma 17:1652).
  ///
  /// Plan progress is deliberately left alone: the day was still done, and
  /// rewinding it would push the Home banner backwards.
  Future<void> deleteSession(int id) async {
    await (_db.delete(
      _db.exerciseLogs,
    )..where((t) => t.sessionLogId.equals(id))).go();
    await (_db.delete(_db.sessionLogs)..where((t) => t.id.equals(id))).go();
  }

  /// How many distinct exercises the user has ever finished.
  Future<int> totalExercisesCompleted() async {
    final rows = await _db.select(_db.exerciseLogs).get();
    return rows.length;
  }

  Future<void> clearAll() async {
    await _db.delete(_db.exerciseLogs).go();
    await _db.delete(_db.sessionLogs).go();
    await _db.delete(_db.planProgressRows).go();
  }
}
