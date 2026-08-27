import 'package:fitness_app/features/discover/models/category_model.dart';

/// One run through an ordered list of exercises.
///
/// The player screens (Figma 11:1201 / 11:1235 / 11:1312) are shared by every
/// flow that can start a workout — Discover, Challenges and Body Focus — so the
/// session carries only what those screens render.
class PlayerSession {
  /// Reuses the Discover flow's [ExerciseModel].
  final List<ExerciseModel> exercises;

  /// Title shown on the paused screen and used when reporting completion.
  final String workoutTitle;

  /// Index of the exercise the player opens on.
  final int startIndex;

  const PlayerSession({
    required this.exercises,
    required this.workoutTitle,
    this.startIndex = 0,
  });

  int get length => exercises.length;

  bool get isEmpty => exercises.isEmpty;

  ExerciseModel exerciseAt(int index) =>
      exercises[index.clamp(0, exercises.length - 1)];

  /// "1/7" — Figma 11:1297.
  String positionLabel(int index) => '${index + 1}/$length';
}

/// How the player finished, returned to whoever pushed it.
enum PlayerOutcome { completed, restart, later, exited }
