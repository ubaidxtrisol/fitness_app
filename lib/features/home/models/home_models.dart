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

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.daysLabel,
    required this.userCount,
    required this.thumbnailUrl,
    this.isFavorite = false,
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
