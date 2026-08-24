import 'package:fitness_app/features/user_info_flow/widgets/activities_chips_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/body_shape_grid_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/injuries_grid_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/subtitled_grid_card_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/workout_level_list_widget.dart';
import 'package:fitness_app/features/user_info_flow/widgets/workout_place_grid_widget.dart';
import 'package:flutter/material.dart';

enum QuestionType {
  heightPicker,
  weightPicker,
  targetWeightPicker,
  currentBodyShape,
  targetBodyShape,
  agePicker,
  workoutPlace,
  activities,
  workoutLevel,
  injuries,
  bellyHipType,
  legType,
}

class QuestionModel {
  final int id;
  final String title;
  final String subtitle;
  final QuestionType type;
  final List<BodyShapeOption> bodyShapeOptions;
  final List<WorkoutPlaceOption> workoutPlaceOptions;
  final List<ActivitiesOption> activitiesOptions;
  final List<WorkoutLevelOption> workoutLevelOptions;
  final List<InjuryOption> injuryOptions;
  final List<SubtitledGridOption> subtitledGridOptions;

  const QuestionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.bodyShapeOptions = const [],
    this.workoutPlaceOptions = const [],
    this.activitiesOptions = const [],
    this.workoutLevelOptions = const [],
    this.injuryOptions = const [],
    this.subtitledGridOptions = const [],
  });
}

class UserInfoQuestions {
  static const List<QuestionModel> questions = [
    // 1. Height
    QuestionModel(
      id: 1,
      title: "What's Your Height?",
      subtitle:
          "Height is crucial to estimate your baseline metabolic rate accurately.",
      type: QuestionType.heightPicker,
    ),
    // 2. Current Weight
    QuestionModel(
      id: 2,
      title: "What's Your Current Weight?",
      subtitle:
          "Used to configure safe calorie deficits and track weight trends.",
      type: QuestionType.weightPicker,
    ),
    // 3. Target Weight
    QuestionModel(
      id: 3,
      title: "What's Your Target Weight?",
      subtitle:
          "Set your goal weight. We'll adjust your macro ratios to get you there safely.",
      type: QuestionType.targetWeightPicker,
    ),
    // 4. Current Body Shape
    QuestionModel(
      id: 4,
      title: "What Is Your Current Body Shape?",
      subtitle:
          "Silhouettes help us personalize your base body-fat calculations.",
      type: QuestionType.currentBodyShape,
      bodyShapeOptions: [
        BodyShapeOption(
          id: 'slim',
          title: 'Slim',
          imagePath: 'assets/images/slim.png',
        ),
        BodyShapeOption(
          id: 'average',
          title: 'Average',
          imagePath: 'assets/images/average.png',
        ),
        BodyShapeOption(
          id: 'heavy',
          title: 'Heavy',
          imagePath: 'assets/images/heavy.png',
        ),
        BodyShapeOption(
          id: 'muscular',
          title: 'Muscular',
          imagePath: 'assets/images/muscular.png',
        ),
      ],
    ),
    // 5. Target Body Shape
    QuestionModel(
      id: 5,
      title: "What's Your Target Body Shape?",
      subtitle:
          "Define your goal physique to configure optimal muscular hypertrophy parameters.",
      type: QuestionType.targetBodyShape,
      bodyShapeOptions: [
        BodyShapeOption(
          id: 'lean',
          title: 'Lean',
          imagePath: 'assets/images/lean.png',
        ),
        BodyShapeOption(
          id: 'toned',
          title: 'Toned',
          imagePath: 'assets/images/toned.png',
        ),
        BodyShapeOption(
          id: 'athletic',
          title: 'Athletic',
          imagePath: 'assets/images/athletic.png',
        ),
        BodyShapeOption(
          id: 'bulk',
          title: 'Bulk',
          imagePath: 'assets/images/bulk.png',
        ),
      ],
    ),
    // 6. Age Picker
    QuestionModel(
      id: 6,
      title: "How Old Are You?",
      subtitle:
          "Age influences physical recovery rates and heart rate zone limits.",
      type: QuestionType.agePicker,
    ),
    // 7. Workout Place
    QuestionModel(
      id: 7,
      title: "Where Do You Typically Workout?",
      subtitle:
          "We will tailor your routine depending on what gear is accessible.",
      type: QuestionType.workoutPlace,
      workoutPlaceOptions: [
        WorkoutPlaceOption(
          id: 'home',
          title: 'Home',
          imagePath: 'assets/images/home.png',
        ),
        WorkoutPlaceOption(
          id: 'gym',
          title: 'Gym',
          imagePath: 'assets/images/gym.png',
        ),
        WorkoutPlaceOption(
          id: 'outdoors',
          title: 'Outdoors',
          imagePath: 'assets/images/outdoors.png',
        ),
        WorkoutPlaceOption(
          id: 'mixed',
          title: 'Mixed',
          imagePath: 'assets/images/mixed.png',
        ),
      ],
    ),
    // 8. Activities
    QuestionModel(
      id: 8,
      title: "What Activities Do You Enjoy?",
      subtitle:
          "Select at least 3 categories to curate your cross-training schedule.",
      type: QuestionType.activities,
      activitiesOptions: [
        ActivitiesOption(id: 'running', title: 'Running'),
        ActivitiesOption(id: 'yoga', title: 'Yoga'),
        ActivitiesOption(id: 'swimming', title: 'Swimming'),
        ActivitiesOption(id: 'cycling', title: 'Cycling'),
        ActivitiesOption(id: 'weight_training', title: 'Weight Training'),
        ActivitiesOption(id: 'hiit', title: 'HIIT'),
        ActivitiesOption(id: 'pilates', title: 'Pilates'),
        ActivitiesOption(id: 'boxing', title: 'Boxing'),
        ActivitiesOption(id: 'dancing', title: 'Dancing'),
      ],
    ),
    // 9. Workout Level
    QuestionModel(
      id: 9,
      title: "What's Your Preferred Workout Level?",
      subtitle: "This adjusts the initial difficulty of your core sets.",
      type: QuestionType.workoutLevel,
      workoutLevelOptions: [
        WorkoutLevelOption(
          id: 'beginner',
          title: 'Beginner',
          subtitle: 'Just starting out on your path',
          icon: Icons.eco_outlined,
        ),
        WorkoutLevelOption(
          id: 'intermediate',
          title: 'Intermediate',
          subtitle: 'Familiar with major muscle exercises',
          icon: Icons.hexagon_outlined,
        ),
        WorkoutLevelOption(
          id: 'advanced',
          title: 'Advanced',
          subtitle: 'Can handle compound and heavy lifts',
          icon: Icons.local_fire_department_outlined,
        ),
        WorkoutLevelOption(
          id: 'expert',
          title: 'Expert',
          subtitle: 'Maximum metabolic physical capacity',
          icon: Icons.emoji_events_outlined,
        ),
      ],
    ),
    // 10. Injuries
    QuestionModel(
      id: 10,
      title: "Do You Have Any Injuries?",
      subtitle:
          "Select the zones you want to protect during physical therapy sessions.",
      type: QuestionType.injuries,
      injuryOptions: [
        InjuryOption(id: 'back', title: 'Back', icon: Icons.person_outline_rounded),
        InjuryOption(id: 'knee', title: 'Knee', icon: Icons.sports_gymnastics_rounded),
        InjuryOption(id: 'shoulder', title: 'Shoulder', icon: Icons.accessibility_new_rounded),
        InjuryOption(id: 'wrist', title: 'Wrist', icon: Icons.pan_tool_outlined),
        InjuryOption(id: 'ankle', title: 'Ankle', icon: Icons.directions_walk_rounded),
        InjuryOption(id: 'hip', title: 'Hip', icon: Icons.airline_seat_legroom_extra_rounded),
        InjuryOption(id: 'none', title: 'None', icon: Icons.shield_outlined),
      ],
    ),
    // 11. Belly & Hip Type
    QuestionModel(
      id: 11,
      title: "Which Type Best Matches Your Belly & Hip?",
      subtitle:
          "Helps estimate targeted visceral fat and customized posture adjustments.",
      type: QuestionType.bellyHipType,
      subtitledGridOptions: [
        SubtitledGridOption(
          id: 'diamond',
          title: 'Diamond',
          subtitle: 'Fat focused on waist',
          imagePath: 'assets/images/diamond.png',
        ),
        SubtitledGridOption(
          id: 'hourglass',
          title: 'Hourglass',
          subtitle: 'Balanced hip and chest',
          imagePath: 'assets/images/hourglass.png',
        ),
        SubtitledGridOption(
          id: 'triangle',
          title: 'Triangle',
          subtitle: 'Wider hips and thighs',
          imagePath: 'assets/images/triangle.png',
        ),
        SubtitledGridOption(
          id: 'inverted',
          title: 'Inverted',
          subtitle: 'Wider chest and narrow...',
          imagePath: 'assets/images/inverted.png',
        ),
      ],
    ),
    // 12. Leg Type
    QuestionModel(
      id: 12,
      title: "Which Best Describes Your Leg Shape?",
      subtitle:
          "Targeted alignments for knee angles, posture correction, and symmetry.",
      type: QuestionType.legType,
      subtitledGridOptions: [
        SubtitledGridOption(
          id: 'normal',
          title: 'Normal',
          subtitle: 'Straight alignment',
          imagePath: 'assets/images/normal.png',
        ),
        SubtitledGridOption(
          id: 'bow_legged',
          title: 'Bow-Legged',
          subtitle: 'Outward bowed knees',
          imagePath: 'assets/images/bow_legged.png',
        ),
        SubtitledGridOption(
          id: 'knock_kneed',
          title: 'Knock-Kneed',
          subtitle: 'Inward touching knees',
          imagePath: 'assets/images/knock_kneed.png',
        ),
        SubtitledGridOption(
          id: 'hyperextend',
          title: 'Hyperextended',
          subtitle: 'Knees bend backwards',
          imagePath: 'assets/images/hyperextend.png',
        ),
      ],
    ),
  ];
}
