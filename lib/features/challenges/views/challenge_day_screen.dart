import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/widgets/challenge_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/step_lock_dialog.dart';
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
/// plain "Exercise N" with no progress pill — plus, once the user has done at
/// least one exercise this run (or finished the day outright), a completion
/// pill and a checkmark on every exercise already logged.
///
/// Days beyond the user's real progress still open (browsing ahead is fine),
/// but [isUnlocked] gates actually starting them — Start and every exercise
/// row explain why with [showStepLockedDialog] instead of navigating.
class ChallengeDayScreen extends StatefulWidget {
  final ChallengeProgramModel challenge;
  final ChallengeWeekModel week;
  final DayModel day;
  final int weekNumber;
  final bool isUnlocked;
  final String currentPositionLabel;

  /// True once every exercise in this exact day has already been finished on
  /// a previous run — its mid-workout checkpoint is long gone by then (it's
  /// cleared the moment a day is actually completed), so this is the only
  /// way to know every exercise counts as done rather than reading an empty
  /// checkpoint as "nothing started yet".
  final bool isCompleted;

  const ChallengeDayScreen({
    super.key,
    required this.challenge,
    required this.week,
    required this.day,
    required this.weekNumber,
    this.isUnlocked = true,
    this.isCompleted = false,
    this.currentPositionLabel = '',
  });

  @override
  State<ChallengeDayScreen> createState() => _ChallengeDayScreenState();
}

class _ChallengeDayScreenState extends State<ChallengeDayScreen> {
  final ActiveSessionRepository _activeSessions = ActiveSessionRepository();

  /// `"<exerciseId>#<index>"` keys — the same dedup format the player itself
  /// logs against, so membership here matches exactly what it counted done.
  Set<String> _doneKeys = const {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ChallengeDayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day.id != widget.day.id ||
        oldWidget.week.id != widget.week.id ||
        oldWidget.isCompleted != widget.isCompleted) {
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.isCompleted) {
      if (!mounted) return;
      setState(() {
        _doneKeys = {
          for (var i = 0; i < widget.day.exercises.length; i++)
            '${widget.day.exercises[i].exerciseId}#$i',
        };
        _loaded = true;
      });
      return;
    }

    final saved = await _activeSessions.find(_planId, widget.day.id);
    if (!mounted) return;
    setState(() {
      _doneKeys = saved == null
          ? const {}
          : _activeSessions
                .decodeCompletedIds(saved.completedExerciseIdsJson)
                .toSet();
      _loaded = true;
    });
  }

  String get _planId => '${widget.challenge.id}/${widget.week.id}';

  bool _isDone(int index) =>
      _doneKeys.contains('${widget.day.exercises[index].exerciseId}#$index');

  int get _doneCount => widget.day.exercises.isEmpty
      ? 0
      : List.generate(
          widget.day.exercises.length,
          _isDone,
        ).where((done) => done).length;

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  /// One definition of this day's run, shared by the Start button and by
  /// "Start Now" on each exercise's detail screen.
  PlayerSession get _session => PlayerSession(
    exercises: widget.day.exercises,
    workoutTitle: '${widget.challenge.title} · ${widget.day.title}',
    planId: _planId,
    planType: PlanType.challenge,
    planTitle: widget.challenge.title,
    dayId: widget.day.id,
    dayTitle: widget.day.title,
    dayLevel: widget.day.difficulty,
    dayIndex: widget.week.days.indexOf(widget.day),
    totalDays: widget.week.days.length,
  );

  void _guard(BuildContext context, VoidCallback action) {
    if (widget.isUnlocked) {
      action();
    } else {
      showStepLockedDialog(
        context,
        currentPositionLabel: widget.currentPositionLabel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final day = widget.day;
    final isUnlocked = widget.isUnlocked;

    final total = day.exercises.length;
    final done = _loaded ? _doneCount : 0;
    final allDone = total > 0 && done >= total;
    final inProgress = _loaded && done > 0 && !allDone;

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
                  leadingTitle: widget.weekNumber.toString().padLeft(2, '0'),
                  leadingSubtitle: 'Week',
                ),
                21.heightBox,

                // Section heading (12:2380) — plus how much of today is
                // already done, once anything has actually started.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercise ${day.exercises.length}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (!isUnlocked)
                      const Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: AppColors.textLight,
                      )
                    else if (allDone)
                      const _CompletionPill(
                        label: 'Completed',
                        color: AppColors.success,
                        background: Color(0xFFE3F6E8),
                        icon: Icons.check_circle_rounded,
                      )
                    else if (inProgress)
                      _CompletionPill(
                        label: '$done/$total',
                        color: AppColors.primary,
                        background: AppColors.primaryLight,
                      ),
                  ],
                ),
                if (inProgress) ...[
                  10.heightBox,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : done / total,
                      minHeight: 6,
                      backgroundColor: AppColors.primaryLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
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
                      isDone: _loaded && _isDone(index),
                      onTap: () => _guard(
                        context,
                        () => context.push(
                          ExerciseDetailScreen(
                            exercise: exercise,
                            dayLabel: day.title,
                            session: _session,
                            exerciseIndex: index,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Start button (12:2422) — opens the shared player, unless this day
          // is still ahead of the user's real progress. Reads "Resume" when
          // there's a mid-workout checkpoint, so it's clear tapping it won't
          // start over from exercise one.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!isUnlocked) {
                      showStepLockedDialog(
                        context,
                        currentPositionLabel: widget.currentPositionLabel,
                      );
                      return;
                    }
                    await context.push(ExercisePlayerScreen(session: _session));
                    // The player may have just changed how much is done.
                    if (!mounted) return;
                    await _load();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUnlocked
                        ? AppColors.primary
                        : const Color(0xFFC9C9C9),
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isUnlocked) ...[
                        const Icon(Icons.lock_rounded, size: 16),
                        8.widthBox,
                      ],
                      Text(
                        inProgress ? 'Resume' : 'Start',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

class _CompletionPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  const _CompletionPill({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
