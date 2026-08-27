import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/body_focus/models/body_focus_model.dart';
import 'package:fitness_app/features/body_focus/views/body_session_screen.dart';
import 'package:fitness_app/features/workout/widgets/day_stats_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// A body-part workout — Figma 14:242.
///
/// Hero, stat strip, then the numbered session rows.
class BodyWorkoutDetailScreen extends StatefulWidget {
  final BodyWorkoutModel workout;

  const BodyWorkoutDetailScreen({super.key, required this.workout});

  @override
  State<BodyWorkoutDetailScreen> createState() =>
      _BodyWorkoutDetailScreenState();
}

class _BodyWorkoutDetailScreenState extends State<BodyWorkoutDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(
        isFavorite: _isFavorite,
        onFavoriteToggled: () => setState(() => _isFavorite = !_isFavorite),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Hero (14:243) — title at (16, 56) inside the banner, note below.
          WorkoutHeroBanner(
            contentPadding: const EdgeInsets.only(left: 16, top: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 133,
                  child: Text(
                    workout.title,
                    // 14:342 is 42 tall — exactly two 23.8 lines.
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19.314,
                      height: 1.232,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFA32045),
                    ),
                  ),
                ),
                12.heightBox,
                Text(
                  workout.note,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA32045),
                  ),
                ),
              ],
            ),
          ),
          13.heightBox,

          // Level / Calories / Net Duration (14:350)
          DayStatsCard(day: workout.statsSource),
          22.heightBox,

          // Session rows (14:393), 11 apart
          ...List.generate(workout.sessions.length, (index) {
            final session = workout.sessions[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == workout.sessions.length - 1 ? 0 : 11,
              ),
              child: WorkoutRowCard.day(
                title: session.title,
                subtitle: session.summaryLabel,
                thumbnailUrl: session.thumbnailUrl,
                badge: (index + 1).toString().padLeft(2, '0'),
                onTap: () => context.push(
                  BodySessionScreen(
                    session: session,
                    workoutTitle: workout.title,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
