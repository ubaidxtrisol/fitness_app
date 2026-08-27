import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/discover/views/exercise_detail_screen.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// A session's exercises — Figma 14:528.
///
/// The leanest of the list screens: titled app bar, exercise rows, Start.
class BodySessionScreen extends StatefulWidget {
  final DayModel session;
  final String workoutTitle;
  final String planId;
  final int sessionIndex;
  final int totalSessions;

  const BodySessionScreen({
    super.key,
    required this.session,
    required this.workoutTitle,
    this.planId = '',
    this.sessionIndex = 0,
    this.totalSessions = 0,
  });

  @override
  State<BodySessionScreen> createState() => _BodySessionScreenState();
}

class _BodySessionScreenState extends State<BodySessionScreen> {
  bool _isFavorite = false;

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// One definition of this session's run, shared by the Start button and by
  /// "Start Now" on each exercise's detail screen.
  PlayerSession get _session => PlayerSession(
    exercises: widget.session.exercises,
    workoutTitle: '${widget.workoutTitle} · ${widget.session.title}',
    planId: widget.planId.isEmpty ? widget.session.id : widget.planId,
    planType: PlanType.bodyFocus,
    planTitle: widget.workoutTitle,
    dayId: widget.session.id,
    dayTitle: widget.session.title,
    dayLevel: widget.session.difficulty,
    dayIndex: widget.sessionIndex,
    totalDays: widget.totalSessions,
  );

  @override
  Widget build(BuildContext context) {
    final exercises = widget.session.exercises;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(
        // 14:642 sets this title in NexaText Regular rather than Nexa Bold.
        title: widget.workoutTitle,
        titleWeight: FontWeight.w400,
        isFavorite: _isFavorite,
        onFavoriteToggled: () => setState(() => _isFavorite = !_isFavorite),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 21, 16, 20),
              physics: const BouncingScrollPhysics(),
              itemCount: exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final exercise = exercises[index];

                return WorkoutRowCard.exercise(
                  title: exercise.title,
                  subtitle: _formatDuration(exercise.durationSeconds),
                  thumbnailUrl: exercise.thumbnailUrl,
                  onTap: () => context.push(
                    ExerciseDetailScreen(
                      exercise: exercise,
                      dayLabel: widget.session.title,
                      showFavorite: true,
                      session: _session,
                      exerciseIndex: index,
                    ),
                  ),
                );
              },
            ),
          ),

          // Start (14:761) — 60 tall here, unlike the 52 on 11:738.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: exercises.isEmpty
                      ? null
                      : () => context.push(
                          ExercisePlayerScreen(session: _session),
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
