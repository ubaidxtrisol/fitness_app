import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';

/// One run through an ordered list of exercises.
///
/// The player screens (Figma 11:1201 / 11:1235 / 11:1312) are shared by every
/// flow that can start a workout — Discover, Challenges, Body Focus and the
/// program flow — so the session also carries the identifiers the progress
/// tables need in order to log the run against the right plan.
class PlayerSession {
  /// Reuses the Discover flow's [ExerciseModel].
  final List<ExerciseModel> exercises;

  /// Title shown on the paused screen and stored against the log.
  final String workoutTitle;

  /// Index of the exercise the player opens on.
  final int startIndex;

  final String planId;
  final String planType;
  final String planTitle;
  final String dayId;
  final String dayTitle;

  /// "Beginner" / "Intermediate" — logged alongside the day so the history
  /// card can read "Day 2. Beginner" (Figma 17:1633).
  final String dayLevel;
  final int dayIndex;
  final int totalDays;

  const PlayerSession({
    required this.exercises,
    required this.workoutTitle,
    this.startIndex = 0,
    this.planId = '',
    this.planType = PlanType.discover,
    this.planTitle = '',
    this.dayId = '',
    this.dayTitle = '',
    this.dayLevel = '',
    this.dayIndex = 0,
    this.totalDays = 0,
  });

  int get length => exercises.length;

  /// The same run, opened on a different exercise — what "Start Now" on the
  /// detail screen (11:959 / 16:356) needs.
  PlayerSession startingAt(int index) => PlayerSession(
    exercises: exercises,
    workoutTitle: workoutTitle,
    startIndex: index.clamp(0, exercises.isEmpty ? 0 : exercises.length - 1),
    planId: planId,
    planType: planType,
    planTitle: planTitle,
    dayId: dayId,
    dayTitle: dayTitle,
    dayLevel: dayLevel,
    dayIndex: dayIndex,
    totalDays: totalDays,
  );

  /// Artwork filed against the log so the history card (Figma 17:1631) has
  /// something to show — the first exercise stands in for the whole run.
  String get thumbnailUrl =>
      exercises.isEmpty ? '' : exercises.first.thumbnailUrl;

  bool get isEmpty => exercises.isEmpty;

  /// True when there is enough plan context to log this run.
  bool get isTrackable => planId.isNotEmpty && dayId.isNotEmpty;

  ExerciseModel exerciseAt(int index) =>
      exercises[index.clamp(0, exercises.length - 1)];

  /// "1/7" — Figma 11:1297.
  String positionLabel(int index) => '${index + 1}/$length';

  /// Total scheduled seconds, used for the session summary.
  int get totalSeconds => exercises.fold(
    0,
    (sum, e) => sum + (e.durationSeconds > 0 ? e.durationSeconds : 35),
  );
}

/// How the player finished, returned to whoever pushed it.
enum PlayerOutcome { completed, restart, later, exited }
