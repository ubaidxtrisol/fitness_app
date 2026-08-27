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

  const ChallengeProgress._(
    this.challenge,
    this._currentDayIndexByWeek,
    this._completedDaysByWeek,
  );

  static Future<ChallengeProgress> resolve(
    ChallengeProgramModel challenge, [
    ProgressRepository? progress,
  ]) async {
    final repo = progress ?? ProgressRepository();
    final currentByWeek = <int>[];
    final completedByWeek = <int>[];

    for (final week in challenge.weeks) {
      final row = await repo.planProgress('${challenge.id}/${week.id}');
      currentByWeek.add(row?.currentDayIndex ?? 0);
      completedByWeek.add(row?.completedDays ?? 0);
    }

    return ChallengeProgress._(challenge, currentByWeek, completedByWeek);
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

  /// "Week 2, Day 3" — the line the lock dialog shows the user.
  String get currentPositionLabel {
    final target = currentTarget;
    if (target == null) return '';
    return 'Week ${target.weekIndex + 1}, ${target.day.title}';
  }
}
