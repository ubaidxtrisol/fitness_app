import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';

/// One Body Focus tile from the Home screen — "Butt & Leg", "Abs", …
class BodyFocusCategoryModel {
  final String id;
  final String title;
  final List<BodyWorkoutModel> workouts;

  const BodyFocusCategoryModel({
    required this.id,
    required this.title,
    required this.workouts,
  });

  factory BodyFocusCategoryModel.fromJson(Map<String, dynamic> json) {
    return BodyFocusCategoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      workouts:
          (json['workouts'] as List<dynamic>?)
              ?.map((e) => BodyWorkoutModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'workouts': workouts.map((e) => e.toJson()).toList(),
  };
}

/// A workout targeting that body part — Figma 14:24 (grid cell) and 14:242
/// (detail).
class BodyWorkoutModel {
  final String id;
  final String title;

  /// Second hero line, e.g. "Note: Image Will Change" (Figma 14:348).
  final String note;
  final String difficulty;
  final int durationMinutes;
  final int netTimeMinutes;
  final int caloriesBurned;
  final String thumbnailUrl;

  /// The numbered rows on 14:242. Reuses [DayModel] because a session and a
  /// program day render the identical row and summary ("5 min . 7 Exercise").
  final List<DayModel> sessions;

  const BodyWorkoutModel({
    required this.id,
    required this.title,
    required this.note,
    required this.difficulty,
    required this.durationMinutes,
    required this.netTimeMinutes,
    required this.caloriesBurned,
    required this.thumbnailUrl,
    required this.sessions,
  });

  /// Adapter so the grid can render the shared [DiscoverWorkoutCard], and the
  /// stat strip can render [DayStatsCard].
  WorkoutModel get card => WorkoutModel(
    id: id,
    title: title,
    difficulty: difficulty,
    durationMinutes: durationMinutes,
    netTimeMinutes: netTimeMinutes,
    caloriesBurned: caloriesBurned,
    thumbnailUrl: thumbnailUrl,
    exercises: sessions.expand((s) => s.exercises).toList(),
  );

  DayModel get statsSource => DayModel(
    id: id,
    title: title,
    difficulty: difficulty,
    durationMinutes: durationMinutes,
    netTimeMinutes: netTimeMinutes,
    caloriesBurned: caloriesBurned,
    thumbnailUrl: thumbnailUrl,
    exercises: const [],
  );

  factory BodyWorkoutModel.fromJson(Map<String, dynamic> json) {
    return BodyWorkoutModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Beginner',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      netTimeMinutes: json['net_time_minutes'] as int? ?? 0,
      caloriesBurned: json['calories_burned'] as int? ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      sessions:
          (json['sessions'] as List<dynamic>?)
              ?.map((e) => DayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'difficulty': difficulty,
    'duration_minutes': durationMinutes,
    'net_time_minutes': netTimeMinutes,
    'calories_burned': caloriesBurned,
    'thumbnail_url': thumbnailUrl,
    'sessions': sessions.map((e) => e.toJson()).toList(),
  };
}
