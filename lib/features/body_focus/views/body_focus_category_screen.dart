import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/body_focus/views/body_workout_detail_screen.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/widgets/discover_workout_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:flutter/material.dart';

/// Workouts for one body part — Figma 14:2.
///
/// Two columns of the shared [DiscoverWorkoutCard] at its grid size, 16.7
/// between columns and 16 between rows.
class BodyFocusCategoryScreen extends StatelessWidget {
  final CategoryModel category;

  const BodyFocusCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // 14:21 still carries the "Challenges" label the frame was copied from;
      // the body part name is what belongs here.
      appBar: WorkoutAppBar(showFavorite: false, title: category.title),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
        physics: const BouncingScrollPhysics(),
        itemCount: category.workouts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.7,
          mainAxisSpacing: 16,
          childAspectRatio:
              DiscoverWorkoutCard.gridWidth / DiscoverWorkoutCard.gridHeight,
        ),
        itemBuilder: (context, index) {
          final workout = category.workouts[index];

          return DiscoverWorkoutCard(
            workout: workout,
            width: DiscoverWorkoutCard.gridWidth,
            height: DiscoverWorkoutCard.gridHeight,
            imageHeight: DiscoverWorkoutCard.gridImageHeight,
            margin: EdgeInsets.zero,
            onTap: () =>
                context.push(BodyWorkoutDetailScreen(workout: workout)),
          );
        },
      ),
    );
  }
}
