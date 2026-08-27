import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';

/// Where one day sits relative to the user's real progress.
enum ChallengeDayStatus {
  /// Already finished — can be freely replayed.
  completed,

  /// The next day to do — the only day beyond [completed] that can be
  /// started.
  current,

  /// Not reachable yet — every earlier day must be finished first.
  locked,
}

/// Real per-user progress through a challenge.
///
/// The content JSON ships a `current_day_index` per week, but it is a static
/// authoring value (always `0`) — this resolves the *actual* position from
/// `plan_progress_rows`, one row per week (`"<challengeId>/<weekId>"`), and
/// enforces that weeks unlock in order: every day in week N+1 stays locked
/// until week N is fully finished, and within a week, day D stays locked
/// until day D-1 is done. That is the "step by step" rule the challenge is
/// built around.
class ChallengeProgress {
  final ChallengeProgramModel challenge;
  final List<int> _currentDayIndexByWeek;
  final List<int> _completedDaysByWeek;

  /// 0.0–1.0: how far into the *current* (not-yet-finished) day the user has
  /// gotten, from that day's `ActiveSessions` checkpoint if one exists. Lets
  /// [percentComplete] move the moment an exercise is logged rather than
  /// only once a whole day is.
  final double _partialDayCredit;

  const ChallengeProgress._(
    this.challenge,
    this._currentDayIndexByWeek,
    this._completedDaysByWeek,
    this._partialDayCredit,
  );

  static Future<ChallengeProgress> resolve(
    ChallengeProgramModel challenge, [
    ProgressRepository? progress,
    ActiveSessionRepository? activeSessions,
  ]) async {
    final repo = progress ?? ProgressRepository();
    final sessions = activeSessions ?? ActiveSessionRepository();
    final currentByWeek = <int>[];
    final completedByWeek = <int>[];

    for (final week in challenge.weeks) {
      final row = await repo.planProgress('${challenge.id}/${week.id}');
      currentByWeek.add(row?.currentDayIndex ?? 0);
      completedByWeek.add(row?.completedDays ?? 0);
    }

    // A day's own checkpoint is cleared once it's actually finished, so this
    // only ever finds something for a day that's genuinely still in flight.
    final withoutCredit = ChallengeProgress._(
      challenge,
      currentByWeek,
      completedByWeek,
      0,
    );
    final target = withoutCredit.currentTarget;
    var partialCredit = 0.0;
    if (target != null &&
        !withoutCredit.isComplete &&
        target.day.exercises.isNotEmpty) {
      final week = challenge.weeks[target.weekIndex];
      final checkpoint = await sessions.find(
        '${challenge.id}/${week.id}',
        target.day.id,
      );
      if (checkpoint != null) {
        final done = sessions
            .decodeCompletedIds(checkpoint.completedExerciseIdsJson)
            .length;
        partialCredit = (done / target.day.exercises.length).clamp(0.0, 1.0);
      }
    }

    return ChallengeProgress._(
      challenge,
      currentByWeek,
      completedByWeek,
      partialCredit,
    );
  }

  /// Week 0 is always open. Week N is open once week N-1's every day is done.
  bool isWeekUnlocked(int weekIndex) {
    if (weekIndex <= 0) return true;
    final previous = challenge.weeks[weekIndex - 1];
    if (previous.days.isEmpty) return true;
    return _completedDaysByWeek[weekIndex - 1] >= previous.days.length;
  }

  ChallengeDayStatus statusOf(int weekIndex, int dayIndex) {
    if (!isWeekUnlocked(weekIndex)) return ChallengeDayStatus.locked;

    final current = _currentDayIndexByWeek[weekIndex];
    if (dayIndex < current) return ChallengeDayStatus.completed;
    if (dayIndex == current) return ChallengeDayStatus.current;
    return ChallengeDayStatus.locked;
  }

  bool isDayUnlocked(int weekIndex, int dayIndex) =>
      statusOf(weekIndex, dayIndex) != ChallengeDayStatus.locked;

  /// The next day the user should do, walking weeks in order the same way
  /// program phases roll over. Points at the final day once everything is
  /// done.
  ({int weekIndex, int dayIndex, DayModel day})? get currentTarget {
    for (var w = 0; w < challenge.weeks.length; w++) {
      final week = challenge.weeks[w];
      if (week.days.isEmpty) continue;

      if (_completedDaysByWeek[w] < week.days.length) {
        final index = _currentDayIndexByWeek[w].clamp(0, week.days.length - 1);
        return (weekIndex: w, dayIndex: index, day: week.days[index]);
      }
    }

    for (var w = challenge.weeks.length - 1; w >= 0; w--) {
      final week = challenge.weeks[w];
      if (week.days.isNotEmpty) {
        return (weekIndex: w, dayIndex: week.days.length - 1, day: week.days.last);
      }
    }
    return null;
  }

  bool get isComplete {
    for (var w = 0; w < challenge.weeks.length; w++) {
      if (_completedDaysByWeek[w] < challenge.weeks[w].days.length) {
        return false;
      }
    }
    return true;
  }

  /// Total days across every week — the denominator for [percentComplete].
  int get totalDays =>
      challenge.weeks.fold(0, (sum, week) => sum + week.days.length);

  /// Days actually finished across every week.
  int get totalCompletedDays =>
      _completedDaysByWeek.fold(0, (sum, count) => sum + count);

  /// 0.0–1.0 across the whole challenge — the number behind the "39%"
  /// progress bar shown on the card and the detail screen. Includes partial
  /// credit for the day currently in flight, so pausing partway through
  /// today's exercises moves this instead of waiting for the whole day.
  double get percentComplete {
    final total = totalDays;
    if (total == 0) return 0;
    return ((totalCompletedDays + _partialDayCredit) / total).clamp(0.0, 1.0);
  }

  /// True once at least one day anywhere in the challenge has been logged —
  /// lets a challenge someone started before "Join" existed (or without
  /// tapping it) still be treated as joined.
  bool get hasProgress => totalCompletedDays > 0;

  /// "Week 2, Day 3" — the line the lock dialog shows the user.
  String get currentPositionLabel {
    final target = currentTarget;
    if (target == null) return '';
    return 'Week ${target.weekIndex + 1}, ${target.day.title}';
  }
}
