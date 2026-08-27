import 'package:fitness_app/features/discover/models/category_model.dart';

/// A training program (Figma `Home` 10:509) — e.g. "Pilates Premier".
class ProgramModel {
  final String id;
  final String title;
  final String subtitle;
  final List<PhaseModel> phases;

  const ProgramModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phases,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      phases:
          (json['phases'] as List<dynamic>?)
              ?.map((e) => PhaseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'phases': phases.map((e) => e.toJson()).toList(),
  };
}

/// One phase of a program — "Phase 1 · Gentle Beginning" with a completion ring.
class PhaseModel {
  final String id;
  final String title;
  final String subtitle;

  /// Completion in the range 0.0 - 1.0. The design ships the 0% state.
  final double progress;
  final List<DayModel> days;

  const PhaseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.days,
  });

  int get progressPercent => (progress * 100).round();

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      days:
          (json['days'] as List<dynamic>?)
              ?.map((e) => DayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'progress': progress,
    'days': days.map((e) => e.toJson()).toList(),
  };
}

/// A single day inside a phase (Figma `Home` 11:738).
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
