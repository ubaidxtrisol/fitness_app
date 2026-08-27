import 'dart:ui';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti_plus/flutter_confetti_plus.dart';

/// The "Workout Complete!" celebration — Requirement: a clear, beautiful
/// finish state once every exercise in the day is done.
///
/// Shown by [ExercisePlayerScreen] right before it hands control back to
/// whoever pushed it. Same visual language as [WorkoutPausedScreen] (the
/// program artwork behind a blurred scrim) so the transition out of the
/// player feels continuous.
class WorkoutCompleteScreen extends StatefulWidget {
  final String planTitle;
  final String dayTitle;
  final int exercisesCompleted;
  final int exercisesTotal;
  final int durationSeconds;
  final int calories;

  const WorkoutCompleteScreen({
    super.key,
    required this.planTitle,
    required this.dayTitle,
    required this.exercisesCompleted,
    required this.exercisesTotal,
    required this.durationSeconds,
    required this.calories,
  });

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ConfettiPlus.success(context);
    });
  }

  String get _duration {
    final mins = (widget.durationSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (widget.durationSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/program_banner.png', fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const ColoredBox(color: Color(0xBFFFFFFF)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                    24.heightBox,
                    const Text(
                      'Workout Complete!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    8.heightBox,
                    Text(
                      '${widget.dayTitle} · ${widget.planTitle}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                    ),
                    32.heightBox,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _Stat(value: _duration, label: 'Duration'),
                          _divider,
                          _Stat(
                            value: '${widget.calories}',
                            label: 'Calories',
                          ),
                          _divider,
                          _Stat(
                            value:
                                '${widget.exercisesCompleted}/'
                                '${widget.exercisesTotal}',
                            label: 'Exercises',
                          ),
                        ],
                      ),
                    ),
                    36.heightBox,
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    22.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const Widget _divider = SizedBox(
    width: 1,
    height: 32,
    child: ColoredBox(color: Color(0xFFF1F1F1)),
  );
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
