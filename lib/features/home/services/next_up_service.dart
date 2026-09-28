import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/joined_challenges_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/workout/models/phase_definitions.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/services/programs_progress.dart';
import 'package:fitness_app/features/workout/services/workout_repository.dart';

/// The day the Home banner should offer, resolved against real progress.
class NextUpTarget {
  final NextUpSuggestion suggestion;

  /// Set when the target is a day in the Phases program (the common case)
  /// — see [WorkoutRepository]/[ProgramsProgress].
  final PhaseDayRef? phaseDay;

  /// Set when the most recent activity was a challenge instead.
  final ChallengeProgramModel? challenge;
  final ChallengeWeekModel? week;
  final DayModel? day;

  const NextUpTarget({
    required this.suggestion,
    this.phaseDay,
    this.challenge,
    this.week,
    this.day,
  });
}

/// Decides what to put in front of the user next.
///
/// Prefers whatever plan they last touched; then a challenge the user joined
/// but hasn't logged a single day of yet (so "Join Challenge" shows up on
/// Home right away, not just after finishing day 1); otherwise falls back to
/// day one of the first bundled program. Everything the banner shows — the
/// day number, the plan name, the "6min/7 Exercise" line — comes from here
/// rather than being hard-coded.
class NextUpService {
  final ProgressRepository _progress;
  final JoinedChallengesRepository _joinedChallenges;

  NextUpService([ProgressRepository? progress, JoinedChallengesRepository? joined])
    : _progress = progress ?? ProgressRepository(),
      _joinedChallenges = joined ?? JoinedChallengesRepository();

  Future<NextUpTarget?> resolve() async {
    final recent = await _progress.mostRecentPlan();

    if (recent != null) {
      final resumed = switch (recent.planType) {
        PlanType.challenge => await _resumeChallenge(recent),
        _ => await _resumeProgram(recent),
      };
      if (resumed != null) return resumed;
    }

    final joined = await _firstJoinedChallenge();
    if (joined != null) return joined;

    return _firstProgramDay();
  }

  Future<NextUpTarget?> _resumeProgram(PlanProgressRow row) async {
    if (row.planId != phasesPlanId) return null;

    final phases = await WorkoutRepository.loadPrograms();
    final progress = await ProgramsProgress.resolve(phases, _progress);
    final ref = progress.currentTarget;
    if (ref == null) return null;

    return NextUpTarget(
      phaseDay: ref,
      suggestion: NextUpSuggestion(
        planId: phasesPlanId,
        planType: PlanType.program,
        planTitle: kPhasesProgramTitle,
        dayTitle: ref.day.title,
        dayIndex: ref.flatIndex,
        totalDays: progress.totalDays,
        exerciseCount: ref.day.exercises.length,
        durationMinutes: ref.day.durationMinutes,
        isResuming: true,
      ),
    );
  }

  Future<NextUpTarget?> _resumeChallenge(PlanProgressRow row) async {
    // Challenge plan ids are stored as "<challengeId>/<weekId>".
    final parts = row.planId.split('/');
    if (parts.length != 2) return null;

    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = _firstWhereOrNull(challenges, (c) => c.id == parts.first);
    if (challenge == null) return null;

    // Progress is tracked per week, but the banner needs one flat position
    // across the whole challenge — this rolls a finished week over into the
    // next one, the same way program phases roll over.
    final progress = await ChallengeProgress.resolve(challenge, _progress);
    final target = progress.currentTarget;
    if (target == null) return null;

    final week = challenge.weeks[target.weekIndex];

    return NextUpTarget(
      challenge: challenge,
      week: week,
      day: target.day,
      suggestion: NextUpSuggestion(
        planId: '${challenge.id}/${week.id}',
        planType: PlanType.challenge,
        planTitle: challenge.title,
        dayTitle: target.day.title,
        dayIndex: target.dayIndex,
        totalDays: week.days.length,
        exerciseCount: target.day.exercises.length,
        durationMinutes: target.day.durationMinutes,
        isResuming: true,
      ),
    );
  }

  /// A challenge the user joined but hasn't logged a single day of yet (so
  /// `mostRecentPlan()` has no row for it at all) — the most recently joined
  /// one that isn't already finished, pointed at its first outstanding day.
  Future<NextUpTarget?> _firstJoinedChallenge() async {
    final joinedRows = await _joinedChallenges.all();
    if (joinedRows.isEmpty) return null;

    final challenges = await ChallengeRepository.loadChallenges();

    for (final row in joinedRows) {
      final challenge = _firstWhereOrNull(
        challenges,
        (c) => c.id == row.challengeId,
      );
      if (challenge == null) continue;

      final progress = await ChallengeProgress.resolve(challenge, _progress);
      // Already finished — don't keep resurfacing it ahead of fresh content.
      if (progress.isComplete) continue;

      final target = progress.currentTarget;
      if (target == null) continue;

      final week = challenge.weeks[target.weekIndex];
      return NextUpTarget(
        challenge: challenge,
        week: week,
        day: target.day,
        suggestion: NextUpSuggestion(
          planId: '${challenge.id}/${week.id}',
          planType: PlanType.challenge,
          planTitle: challenge.title,
          dayTitle: target.day.title,
          dayIndex: target.dayIndex,
          totalDays: week.days.length,
          exerciseCount: target.day.exercises.length,
          durationMinutes: target.day.durationMinutes,
          isResuming: false,
        ),
      );
    }
    return null;
  }

  /// The true fresh-install default — nothing touched yet. The banner reads
  /// "Keep Walking, Keep Going" for this (see [HomeHeroBanner]) and its CTA
  /// opens the Phases browsing screen rather than jumping straight into Day
  /// 1 (that only happens once [_resumeProgram] finds real progress).
  Future<NextUpTarget?> _firstProgramDay() async {
    final phases = await WorkoutRepository.loadPrograms();
    final progress = await ProgramsProgress.resolve(phases, _progress);
    final ref = progress.currentTarget;
    if (ref == null) return null;

    return NextUpTarget(
      phaseDay: ref,
      suggestion: NextUpSuggestion(
        planId: phasesPlanId,
        planType: PlanType.program,
        planTitle: kPhasesProgramTitle,
        dayTitle: ref.day.title,
        dayIndex: ref.flatIndex,
        totalDays: progress.totalDays,
        exerciseCount: ref.day.exercises.length,
        durationMinutes: ref.day.durationMinutes,
        isResuming: false,
      ),
    );
  }

  static T? _firstWhereOrNull<T>(List<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }
}
