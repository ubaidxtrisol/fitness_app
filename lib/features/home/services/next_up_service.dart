import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/services/workout_repository.dart';

/// The day the Home banner should offer, resolved against real progress.
class NextUpTarget {
  final NextUpSuggestion suggestion;

  /// Set when the target is a program day (the common case).
  final ProgramModel? program;
  final PhaseModel? phase;
  final DayModel? day;

  /// Set when the most recent activity was a challenge instead.
  final ChallengeProgramModel? challenge;
  final ChallengeWeekModel? week;

  const NextUpTarget({
    required this.suggestion,
    this.program,
    this.phase,
    this.day,
    this.challenge,
    this.week,
  });
}

/// Decides what to put in front of the user next.
///
/// Prefers whatever plan they last touched; otherwise falls back to day one of
/// the first bundled program. Everything the banner shows — the day number, the
/// plan name, the "6min/7 Exercise" line — comes from here rather than being
/// hard-coded.
class NextUpService {
  final ProgressRepository _progress;

  NextUpService([ProgressRepository? progress])
    : _progress = progress ?? ProgressRepository();

  Future<NextUpTarget?> resolve() async {
    final recent = await _progress.mostRecentPlan();

    if (recent != null) {
      final resumed = switch (recent.planType) {
        PlanType.challenge => await _resumeChallenge(recent),
        _ => await _resumeProgram(recent),
      };
      if (resumed != null) return resumed;
    }

    return _firstProgramDay();
  }

  Future<NextUpTarget?> _resumeProgram(PlanProgressRow row) async {
    final programs = await WorkoutRepository.loadPrograms();
    final program = _firstWhereOrNull(programs, (p) => p.id == row.planId);
    if (program == null) return null;

    // Walk the phases as one flat list of days so a finished phase rolls over.
    final days = <({PhaseModel phase, DayModel day, int index})>[];
    for (final phase in program.phases) {
      for (var i = 0; i < phase.days.length; i++) {
        days.add((phase: phase, day: phase.days[i], index: i));
      }
    }
    if (days.isEmpty) return null;

    final target = days[row.currentDayIndex.clamp(0, days.length - 1)];
    return NextUpTarget(
      program: program,
      phase: target.phase,
      day: target.day,
      suggestion: NextUpSuggestion(
        planId: program.id,
        planType: PlanType.program,
        planTitle: '${program.title} ${program.subtitle}',
        dayTitle: target.day.title,
        dayIndex: target.index,
        totalDays: target.phase.days.length,
        exerciseCount: target.day.exercises.length,
        durationMinutes: target.day.durationMinutes,
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

    final week = _firstWhereOrNull(challenge.weeks, (w) => w.id == parts.last);
    if (week == null || week.days.isEmpty) return null;

    final index = row.currentDayIndex.clamp(0, week.days.length - 1);
    final day = week.days[index];

    return NextUpTarget(
      challenge: challenge,
      week: week,
      day: day,
      suggestion: NextUpSuggestion(
        planId: row.planId,
        planType: PlanType.challenge,
        planTitle: challenge.title,
        dayTitle: day.title,
        dayIndex: index,
        totalDays: week.days.length,
        exerciseCount: day.exercises.length,
        durationMinutes: day.durationMinutes,
        isResuming: true,
      ),
    );
  }

  Future<NextUpTarget?> _firstProgramDay() async {
    final programs = await WorkoutRepository.loadPrograms();
    if (programs.isEmpty) return null;

    final program = programs.first;
    if (program.phases.isEmpty || program.phases.first.days.isEmpty) return null;

    final phase = program.phases.first;
    final day = phase.days.first;

    return NextUpTarget(
      program: program,
      phase: phase,
      day: day,
      suggestion: NextUpSuggestion(
        planId: program.id,
        planType: PlanType.program,
        planTitle: '${program.title} ${program.subtitle}',
        dayTitle: day.title,
        dayIndex: 0,
        totalDays: phase.days.length,
        exerciseCount: day.exercises.length,
        durationMinutes: day.durationMinutes,
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
