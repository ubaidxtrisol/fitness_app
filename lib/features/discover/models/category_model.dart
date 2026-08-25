class CategoryModel {
  final String id;
  final String title;
  final String description;
  final List<WorkoutModel> workouts;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.workouts,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      workouts:
          (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'workouts': workouts.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkoutModel {
  final String id;
  final String title;
  final String difficulty;
  final int durationMinutes;
  final int netTimeMinutes;
  final int caloriesBurned;
  final String thumbnailUrl;
  final List<ExerciseModel> exercises;

  const WorkoutModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.durationMinutes,
    required this.netTimeMinutes,
    required this.caloriesBurned,
    required this.thumbnailUrl,
    required this.exercises,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
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

  Map<String, dynamic> toJson() {
    return {
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
}

class ExerciseModel {
  final int order;
  final String exerciseId;
  final String title;
  final String description;
  final int durationSeconds;
  final int reps;
  final int restSeconds;
  final String thumbnailUrl;
  final String videoUrl;
  final List<String> howToDo;
  final List<String> commonMistakes;
  final List<String> breathingTips;

  const ExerciseModel({
    required this.order,
    required this.exerciseId,
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.reps,
    required this.restSeconds,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.howToDo,
    required this.commonMistakes,
    required this.breathingTips,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      order: json['order'] as int? ?? 0,
      exerciseId: json['exercise_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
      restSeconds: json['rest_seconds'] as int? ?? 0,
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      howToDo:
          (json['how_to_do'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      commonMistakes:
          (json['common_mistakes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      breathingTips:
          (json['breathing_tips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'exercise_id': exerciseId,
      'title': title,
      'description': description,
      'duration_seconds': durationSeconds,
      'reps': reps,
      'rest_seconds': restSeconds,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'how_to_do': howToDo,
      'common_mistakes': commonMistakes,
      'breathing_tips': breathingTips,
    };
  }
}
