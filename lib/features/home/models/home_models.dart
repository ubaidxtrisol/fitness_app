class TodaySummaryModel {
  final int calories;
  final int minutes;
  final int workoutsCount;
  final int streakDays;

  const TodaySummaryModel({
    required this.calories,
    required this.minutes,
    required this.workoutsCount,
    required this.streakDays,
  });
}

class ChallengeModel {
  final String id;
  final String title;
  final String daysLabel;
  final String userCount;
  final String thumbnailUrl;
  final bool isFavorite;

  /// True once the user has tapped "Join" on this challenge (or made real
  /// progress on it before Join existed) — gates whether the card shows the
  /// Join pill or the progress bar/"Completed" badge below.
  final bool isJoined;

  /// 0.0–1.0 across the whole challenge. Only meaningful (and only rendered)
  /// when [isJoined] is true.
  final double percentComplete;

  /// True once every day in every week is done — shows a "Completed" badge
  /// instead of the progress bar.
  final bool isCompleted;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.daysLabel,
    required this.userCount,
    required this.thumbnailUrl,
    this.isFavorite = false,
    this.isJoined = false,
    this.percentComplete = 0,
    this.isCompleted = false,
  });
}

class BodyFocusModel {
  final String id;
  final String title;
  final String imagePath;

  const BodyFocusModel({
    required this.id,
    required this.title,
    required this.imagePath,
  });
}
