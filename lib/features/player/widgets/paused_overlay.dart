import 'dart:ui';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// The paused state's scrim + still + three actions (Figma 11:1312/11:1360/
/// 11:1393), minus the background artwork underneath — whoever hosts this
/// already has the same `program_banner.png` painted behind it.
///
/// Shared by [WorkoutPausedScreen] (its own route, for callers that still want
/// a real screen) and [ExercisePlayerScreen], which shows this in place via
/// `AnimatedSwitcher` instead of navigating away, so a back-button tap or a
/// tap on the transport's pause glyph never leaves the exercise mid-run.
class PausedOverlay extends StatelessWidget {
  final VoidCallback onKeepExercising;
  final VoidCallback onRestart;
  final VoidCallback onLater;

  const PausedOverlay({
    super.key,
    required this.onKeepExercising,
    required this.onRestart,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // The exercise still (11:1314) — 393x237 from the top of the artwork.
        Positioned(
          left: 0,
          right: 0,
          top: 49,
          height: 237,
          child: Image.asset('assets/images/player_model.png', fit: BoxFit.cover),
        ),

        // Scrim + blur (11:1360)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: const ColoredBox(color: Color(0xBFFFFFFF)),
        ),

        // Actions (11:1393)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _PillButton(
                  label: 'Keep exercising',
                  background: AppColors.primary,
                  foreground: AppColors.surface,
                  onTap: onKeepExercising,
                ),
                const SizedBox(height: 17),
                _PillButton(
                  label: 'Restart Workout',
                  background: const Color(0xFFC9C9C9),
                  foreground: AppColors.textLight,
                  onTap: onRestart,
                ),
                const SizedBox(height: 17),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLater,
                  child: const Text(
                    'Do it Later',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
