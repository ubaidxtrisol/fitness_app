import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The "Get Ready!" sheet content (Figma 11:1220) — the live countdown number,
/// the exercise title and the Skip pill.
///
/// Pulled out of [GetReadyScreen] so the exact same card can sit inside
/// [ExercisePlayerScreen]'s own get-ready phase without a second route: the
/// countdown ticker stays owned by whichever screen is showing it, this widget
/// just renders whatever remaining count it's handed.
class GetReadyCard extends StatelessWidget {
  /// Seconds left; 0 (or less) shows "Get Ready!" instead of a number.
  final int remaining;
  final String exerciseTitle;
  final VoidCallback onSkip;

  const GetReadyCard({
    super.key,
    required this.remaining,
    required this.exerciseTitle,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 39, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Heading block (11:1220) — shows the live count once the
          // countdown is running.
          Text(
            remaining > 0 ? '$remaining' : 'Get Ready!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 29.12,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            exerciseTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              height: 1.125,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Start Your Practice Now',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Skip button (11:1223) with its trailing arrow pill.
          GestureDetector(
            onTap: onSkip,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 11,
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/arrow_right.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
