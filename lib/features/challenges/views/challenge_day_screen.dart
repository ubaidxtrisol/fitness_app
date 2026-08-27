import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/widgets/challenge_hero_banner.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/widgets/day_stats_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// A challenge day's exercises — Figma 12:2319.
///
/// Same structure as the workout day screen (11:738); the stat strip leads with
/// the week number instead of the difficulty, and the section heading is a
/// plain "Exercise N" with no progress pill.
class ChallengeDayScreen extends StatelessWidget {
  final ChallengeProgramModel challenge;
  final ChallengeWeekModel week;
  final DayModel day;
  final int weekNumber;

  const ChallengeDayScreen({
    super.key,
    required this.challenge,
    required this.week,
    required this.day,
    required this.weekNumber,
  });

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WorkoutAppBar(showFavorite: false),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // Hero (12:2480) — "Day 1" over the challenge name.
                ChallengeHeroBanner(
                  contentPadding: const EdgeInsets.only(left: 24, top: 58),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day.title,
                        style: const TextStyle(
                          fontSize: 29.308,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      6.513.heightBox,
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          fontSize: 17.91,
                          height: 1.1,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                18.heightBox,

                // Week / Calories / Net Duration (12:2344)
                DayStatsCard(
                  day: day,
                  leadingTitle: weekNumber.toString().padLeft(2, '0'),
                  leadingSubtitle: 'Week',
                ),
                21.heightBox,

                // Section heading (12:2380)
                Text(
                  'Exercise ${day.exercises.length}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                16.heightBox,

                ...List.generate(day.exercises.length, (index) {
                  final exercise = day.exercises[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == day.exercises.length - 1 ? 0 : 14,
                    ),
                    child: WorkoutRowCard.exercise(
                      title: exercise.title,
                      subtitle: _formatDuration(exercise.durationSeconds),
                      thumbnailUrl: exercise.thumbnailUrl,
                      onTap: () => context.push(
                        ExerciseDetailScreen(
                          exercise: exercise,
                          dayLabel: day.title,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Start button (12:2422) — opens the shared player.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () => context.push(
                    ExercisePlayerScreen(
                      session: PlayerSession(
                        exercises: day.exercises,
                        workoutTitle: '${challenge.title} · ${day.title}',
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
