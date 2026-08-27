import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';

/// A challenge — Figma 11:1397 (grid) and 11:1744 (detail).
class ChallengeProgramModel {
  final String id;

  /// Leading half of the hero title, e.g. "Belly " in "Belly Flat" (12:1872).
  final String titleLead;

  /// Accent half of the hero title, drawn in `Color 1`.
  final String titleAccent;

  /// Name used in the app bar and on the day screen, e.g. "Flat Belly".
  final String title;
  final String daysLabel;
  final String userCount;
  final String thumbnailUrl;
  final bool isFavorite;
  final List<ChallengeWeekModel> weeks;

  const ChallengeProgramModel({
    required this.id,
    required this.titleLead,
    required this.titleAccent,
    required this.title,
    required this.daysLabel,
    required this.userCount,
    required this.thumbnailUrl,
    this.isFavorite = false,
    required this.weeks,
  });

  /// Adapter so the grid/rail can render the shared [ChallengeCardWidget].
  ///
  /// The progress fields are optional because computing them needs a DB read
  /// per joined challenge (via `ChallengeProgress.resolve`) — callers only
  /// pass them once they already know this challenge is joined.
  ChallengeModel card({
    bool isJoined = false,
    double percentComplete = 0,
    bool isCompleted = false,
  }) => ChallengeModel(
    id: id,
    title: title,
    daysLabel: daysLabel,
    userCount: userCount,
    thumbnailUrl: thumbnailUrl,
    isFavorite: isFavorite,
    isJoined: isJoined,
    percentComplete: percentComplete,
    isCompleted: isCompleted,
  );

  factory ChallengeProgramModel.fromJson(Map<String, dynamic> json) {
    return ChallengeProgramModel(
      id: json['id'] as String? ?? '',
      titleLead: json['title_lead'] as String? ?? '',
      titleAccent: json['title_accent'] as String? ?? '',
      title: json['title'] as String? ?? '',
      daysLabel: json['days_label'] as String? ?? '',
      userCount: json['user_count'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      isFavorite: json['is_favorite'] as bool? ?? false,
      weeks:
          (json['weeks'] as List<dynamic>?)
              ?.map(
                (e) => ChallengeWeekModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_lead': titleLead,
    'title_accent': titleAccent,
    'title': title,
    'days_label': daysLabel,
    'user_count': userCount,
    'thumbnail_url': thumbnailUrl,
    'is_favorite': isFavorite,
    'weeks': weeks.map((e) => e.toJson()).toList(),
  };
}

/// "Week 1 · Belly Action" plus its seven days — Figma 12:1937.
class ChallengeWeekModel {
  final String id;
  final String title;
  final String subtitle;

  /// Index of the day the user is on; earlier days read as complete.
  final int currentDayIndex;

  /// Reuses the workout flow's [DayModel] — a challenge day and a program day
  /// render the same screen (Figma 12:2319 / 11:738).
  final List<DayModel> days;

  const ChallengeWeekModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.currentDayIndex,
    required this.days,
  });

  factory ChallengeWeekModel.fromJson(Map<String, dynamic> json) {
    return ChallengeWeekModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      currentDayIndex: json['current_day_index'] as int? ?? 0,
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
    'current_day_index': currentDayIndex,
    'days': days.map((e) => e.toJson()).toList(),
  };
}
