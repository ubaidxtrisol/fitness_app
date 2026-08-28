import 'package:fitness_app/features/discover/models/category_model.dart';

/// A single day's exercise list — shared by the program flow (a "day"), the
/// challenge flow (also a "day") and Body Focus (a workout's own exercise
/// list, once resolved). Figma `Home` 11:738.
///
/// The backend's real catalogue shape is flat `Category → Workout →
/// Exercise` (see `apis/readme-cLqG (2).md`) — a `DayModel` is built at the
/// UI boundary via `DayModel.fromJson(workout.toJson())` wherever a screen
/// still wants the "day" framing (`WorkoutModel` and `DayModel` share every
/// field). Programs and Body Focus have both been adapted to consume
/// `CategoryModel`/`WorkoutModel` directly (see `WorkoutRepository`,
/// `BodyFocusRepository`) — `DayModel` now exists purely for Challenges
/// (`ChallengeWeekModel.days`, `ChallengeDayScreen`), which keep their real
/// week/day structure since the bundled content still has it.
class DayModel {
  final String id;
  final String title;
  final String difficulty;
  final int durationMinutes;
  final int netTimeMinutes;
  final int caloriesBurned;
  final String thumbnailUrl;

  /// Reuses the Discover flow's [ExerciseModel] — the two flows share the
  /// exercise detail screen (Figma 11:959 / 16:356).
  final List<ExerciseModel> exercises;

  const DayModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.durationMinutes,
    required this.netTimeMinutes,
    required this.caloriesBurned,
    required this.thumbnailUrl,
    required this.exercises,
  });

  /// "5 min . 7 Exercise" — the day row subtitle in Figma 11:770.
  String get summaryLabel =>
      '$durationMinutes min . ${exercises.length} Exercise';

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      netTimeMinutes: json['net_time_minutes'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'difficulty': difficulty,
    'duration_minutes': durationMinutes,
    'net_time_minutes': netTimeMinutes,
    'calories_burned': caloriesBurned,
    'thumbnail_url': thumbnailUrl,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };
}
