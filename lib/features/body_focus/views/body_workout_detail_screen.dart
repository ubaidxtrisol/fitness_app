import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/widgets/day_stats_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// A body-part workout — Figma 14:242.
///
/// Hero, stat strip, exercise rows, Start. The backend's Body Focus tab has
/// no "session" concept (see `BodyFocusRepository`) — every exercise the
/// workout carries shows directly in one flat list, the same shape Discover
/// and Programs both use for their own workout detail screens.
class BodyWorkoutDetailScreen extends StatefulWidget {
  final WorkoutModel workout;

  const BodyWorkoutDetailScreen({super.key, required this.workout});

  @override
  State<BodyWorkoutDetailScreen> createState() =>
      _BodyWorkoutDetailScreenState();
}

class _BodyWorkoutDetailScreenState extends State<BodyWorkoutDetailScreen> {
  bool _isFavorite = false;

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// One definition of this workout's run, shared by the Start button and by
  /// "Start Now" on each exercise's detail screen.
  PlayerSession get _session => PlayerSession(
    exercises: widget.workout.exercises,
    workoutTitle: widget.workout.title,
    planId: widget.workout.id,
    planType: PlanType.bodyFocus,
    planTitle: widget.workout.title,
    dayId: widget.workout.id,
    dayTitle: widget.workout.title,
    dayLevel: widget.workout.difficulty,
    totalDays: 1,
  );

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(
        isFavorite: _isFavorite,
        onFavoriteToggled: () => setState(() => _isFavorite = !_isFavorite),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // Hero (14:243) — title at (16, 56) inside the banner. The
                // design's second "note" line has no backend equivalent (and
                // was placeholder-only copy on every bundled workout) so it's
                // simply not shown rather than faked.
                WorkoutHeroBanner(
                  contentPadding: const EdgeInsets.only(left: 16, top: 56),
                  thumbnailUrl: workout.thumbnailUrl,
                  child: SizedBox(
                    width: 133,
                    // 14:342 is 42 tall — exactly two 23.8 lines.
                    child: Text(
                      workout.title,
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
                ),
                13.heightBox,

                // Level / Calories / Net Duration (14:350) — a workout and a
                // day carry the identical stat fields.
                DayStatsCard(day: DayModel.fromJson(workout.toJson())),
                22.heightBox,

                // Exercise rows, 14 apart.
                ...List.generate(workout.exercises.length, (index) {
                  final exercise = workout.exercises[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == workout.exercises.length - 1 ? 0 : 14,
                    ),
                    child: WorkoutRowCard.exercise(
                      title: exercise.title,
                      subtitle: _formatDuration(exercise.durationSeconds),
                      thumbnailUrl: exercise.thumbnailUrl,
                      onTap: () => context.push(
                        ExerciseDetailScreen(
                          exercise: exercise,
                          dayLabel: workout.title,
                          showFavorite: true,
                          session: _session,
                          exerciseIndex: index,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Start button (14:761).
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: workout.exercises.isEmpty
                      ? null
                      : () =>
                            context.push(ExercisePlayerScreen(session: _session)),
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
