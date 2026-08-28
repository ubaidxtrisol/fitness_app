import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/widgets/day_stats_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// A day's exercise list — Figma `Home` 11:738.
///
/// Used by the program flow's Next Up path. [programName] is the category's
/// display title (there is no separate "phase" concept — the backend's
/// Programs tab is a flat `Category → Workout → Exercise` catalogue, see
/// `WorkoutRepository`) and [programId] is that category's id, threaded
/// through to the player session for progress logging.
class DayDetailScreen extends StatefulWidget {
  final DayModel day;
  final String programName;
  final String programId;
  final int dayIndex;
  final int totalDays;

  const DayDetailScreen({
    super.key,
    required this.day,
    required this.programName,
    this.programId = '',
    this.dayIndex = 0,
    this.totalDays = 0,
  });

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  bool _isFavorite = false;

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// One definition of this day's run, shared by the Start button and by
  /// "Start Now" on each exercise's detail screen.
  PlayerSession get _session => PlayerSession(
    exercises: widget.day.exercises,
    workoutTitle: '${widget.programName} · ${widget.day.title}',
    planId: widget.programId,
    planType: PlanType.program,
    planTitle: widget.programName,
    dayId: widget.day.id,
    dayTitle: widget.day.title,
    dayLevel: widget.day.difficulty,
    dayIndex: widget.dayIndex,
    totalDays: widget.totalDays,
  );

  @override
  Widget build(BuildContext context) {
    final day = widget.day;

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
                // Hero banner (11:958) — "Day 1" over the program name.
                WorkoutHeroBanner(
                  contentPadding: const EdgeInsets.only(left: 22, top: 46),
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
                        widget.programName,
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
                16.heightBox,

                // Level / Calories / Net Duration (11:852).
                DayStatsCard(day: day),
                21.heightBox,

                // Exercise rows (11:934), 14 apart. The design's "Phase 1 ·
                // Gentle Beginning" header above these rows had no real data
                // behind it (the model's own progress field was permanently
                // hardcoded to 0) and the backend has no phase concept at
                // all, so it's dropped rather than faked.
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

          // Start button (11:1191).
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
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
