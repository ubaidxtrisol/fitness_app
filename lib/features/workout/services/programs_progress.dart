import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/workout/models/phase_definitions.dart';

/// One synthetic plan id covers the whole Phases program so the Home banner
/// can count "Day 5", "Day 6" straight across phase boundaries, the same
/// way a single program's days always have.
const String phasesPlanId = 'phases_program';

/// One loaded day, bucketed into its fixed [PhaseDefinition] by absolute
/// position (see [ProgramsProgress]).
class PhaseDayRef {
  final int phaseIndex;

  /// Index within the phase's *actually loaded* days (not the phase's full
  /// day range, which may not be authored yet).
  final int dayIndex;
  final int flatIndex;
  final PhaseDefinition phase;
  final WorkoutModel day;

  const PhaseDayRef({
    required this.phaseIndex,
    required this.dayIndex,
    required this.flatIndex,
    required this.phase,
    required this.day,
  });
}

/// Real per-user progress through the Phases program.
///
/// Every category `WorkoutRepository.loadPrograms()` returns is flattened
/// into one ordered list of days (across every category, in order) and
/// bucketed into the 4 fixed [kPhaseDefinitions] by absolute day position —
/// day 1-3 is Phase 1 regardless of which category it was loaded from. That
/// keeps the phase boundaries stable even though only a few days are
/// authored today (Phase 2-4 simply show no days yet, not an error).
/// Mirrors `ChallengeProgress` (phase ~ week, day ~ day) and reuses its
/// [ChallengeDayStatus] — same three states, same "browse ahead, can't
/// start ahead" rule. One `plan_progress_rows` row for the whole program
/// under [phasesPlanId], walking every loaded day in order.
class ProgramsProgress {
  final List<PhaseDayRef> _flat;
  final int _currentDayIndex;
  final int _completedDays;
  final double _partialCredit;

  const ProgramsProgress._(
    this._flat,
    this._currentDayIndex,
    this._completedDays,
    this._partialCredit,
  );

  static List<PhaseDayRef> _flatten(List<CategoryModel> categories) {
    final days = categories.expand((c) => c.workouts).toList();
    final flat = <PhaseDayRef>[];
    final countByPhase = List.filled(kPhaseDefinitions.length, 0);

    for (var i = 0; i < days.length; i++) {
      final dayNumber = i + 1; // 1-based absolute position.
      final phaseIndex = kPhaseDefinitions.indexWhere(
        (p) => dayNumber >= p.startDay && dayNumber <= p.endDay,
      );
      // Past the program's fixed 30 days — nowhere to bucket it, skip.
      if (phaseIndex == -1) continue;

      flat.add(
        PhaseDayRef(
          phaseIndex: phaseIndex,
          dayIndex: countByPhase[phaseIndex],
          flatIndex: flat.length,
          phase: kPhaseDefinitions[phaseIndex],
          day: days[i],
        ),
      );
      countByPhase[phaseIndex]++;
    }
    return flat;
  }

  static Future<ProgramsProgress> resolve(
    List<CategoryModel> categories, [
    ProgressRepository? progress,
    ActiveSessionRepository? activeSessions,
  ]) async {
    final repo = progress ?? ProgressRepository();
    final sessions = activeSessions ?? ActiveSessionRepository();
    final flat = _flatten(categories);

    final row = await repo.planProgress(phasesPlanId);
    final currentDayIndex = row?.currentDayIndex ?? 0;
    final completedDays = row?.completedDays ?? 0;

    var partialCredit = 0.0;
    if (currentDayIndex < flat.length) {
      final target = flat[currentDayIndex];
      if (target.day.exercises.isNotEmpty) {
        final checkpoint = await sessions.find(phasesPlanId, target.day.id);
        if (checkpoint != null) {
          final done = sessions
              .decodeCompletedIds(checkpoint.completedExerciseIdsJson)
              .length;
          partialCredit = (done / target.day.exercises.length).clamp(0.0, 1.0);
        }
      }
    }

    return ProgramsProgress._(flat, currentDayIndex, completedDays, partialCredit);
  }

  /// How many days are actually loaded (may be fewer than
  /// [kPhasesProgramTotalDays] until the rest is authored).
  int get totalDays => _flat.length;

  /// The days actually loaded for one phase — may be fewer than the phase's
  /// full range (or empty) if that stretch isn't authored yet.
  List<PhaseDayRef> daysInPhase(int phaseIndex) =>
      _flat.where((r) => r.phaseIndex == phaseIndex).toList();

  /// Phase 0 is always open. Phase N is open once every *loaded* day in
  /// phase N-1 is done — a phase with nothing authored yet counts as done
  /// (nothing to block on) rather than permanently locking everything after
  /// it.
  bool isPhaseUnlocked(int phaseIndex) {
    if (phaseIndex <= 0) return true;
    final previous = daysInPhase(phaseIndex - 1);
    if (previous.isEmpty) return isPhaseUnlocked(phaseIndex - 1);
    return previous.last.flatIndex + 1 <= _currentDayIndex;
  }

  ChallengeDayStatus statusOf(int phaseIndex, int dayIndexInPhase) {
    if (!isPhaseUnlocked(phaseIndex)) return ChallengeDayStatus.locked;

    final refs = daysInPhase(phaseIndex);
    if (dayIndexInPhase >= refs.length) return ChallengeDayStatus.locked;

    final flatIndex = refs[dayIndexInPhase].flatIndex;
    if (_currentDayIndex > flatIndex) return ChallengeDayStatus.completed;
    if (_currentDayIndex == flatIndex) return ChallengeDayStatus.current;
    return ChallengeDayStatus.locked;
  }

  bool isDayUnlocked(int phaseIndex, int dayIndexInPhase) =>
      statusOf(phaseIndex, dayIndexInPhase) != ChallengeDayStatus.locked;

  /// The flattened ref for one specific day — what [PhasesScreen] needs to
  /// log progress against the right flat position without re-deriving it.
  PhaseDayRef refAt(int phaseIndex, int dayIndex) =>
      daysInPhase(phaseIndex)[dayIndex];

  /// The next day the user should do, walking every loaded day in order.
  /// Points at the final day once everything loaded is done.
  PhaseDayRef? get currentTarget {
    if (_flat.isEmpty) return null;
    final index = _currentDayIndex.clamp(0, _flat.length - 1);
    return _flat[index];
  }

  bool get isComplete =>
      _flat.isNotEmpty && _completedDays >= kPhasesProgramTotalDays;

  /// 0.0-1.0 against the program's fixed 30-day length (Figma 11:763 —
  /// "Overall Days Done"), including partial credit for the day currently
  /// in flight, not just however many days happen to be authored so far.
  double get percentComplete {
    return ((_completedDays + _partialCredit) / kPhasesProgramTotalDays)
        .clamp(0.0, 1.0);
  }

  /// 0.0-1.0 for one phase alone, against that phase's own fixed day-range
  /// length (Figma 11:763's per-phase ring, not the whole-program stat) —
  /// includes partial credit when the in-flight day falls in this phase.
  double percentForPhase(int phaseIndex) {
    final phase = kPhaseDefinitions[phaseIndex];
    final completed = daysInPhase(phaseIndex)
        .where((r) => r.flatIndex < _currentDayIndex)
        .length;
    final target = currentTarget;
    final credit = completed + (target?.phaseIndex == phaseIndex ? _partialCredit : 0);
    return (credit / phase.dayCount).clamp(0.0, 1.0);
  }

  /// "X of 30 Days" — the label behind the overall progress bar.
  String get overallDaysLabel => '$_completedDays of $kPhasesProgramTotalDays Days';

  bool get hasProgress => _completedDays > 0;

  /// "Phase 2, Day 5" — the line a lock dialog shows.
  String get currentPositionLabel {
    final target = currentTarget;
    if (target == null) return '';
    return '${target.phase.title}, ${target.day.title}';
  }

  /// Builds the [PlanType.program] session-log identity for a day —
  /// `dayIndex`/`totalDays` are its *flat* position across every loaded
  /// day, matching what `PlanProgressRows` tracks.
  ({String planId, int dayIndex, int totalDays}) planFieldsFor(
    PhaseDayRef ref,
  ) => (planId: phasesPlanId, dayIndex: ref.flatIndex, totalDays: _flat.length);
}
