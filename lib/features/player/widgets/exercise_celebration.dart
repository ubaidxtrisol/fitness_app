import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// The in-place celebration shown the instant an exercise finishes.
///
/// [ExercisePlayerScreen] swaps into this via `AnimatedSwitcher` — a confetti
/// burst (triggered by the caller, which owns the ticker/`BuildContext`
/// lifetime) plus this card — then rings a sound and starts the next
/// exercise's get-ready countdown, rather than jumping straight into it.
class ExerciseCelebration extends StatelessWidget {
  final String title;

  /// The exercise coming up next; omitted after the very last one (that case
  /// goes to [WorkoutCompleteScreen] instead, never through this widget).
  final String? nextTitle;

  const ExerciseCelebration({super.key, required this.title, this.nextTitle});

  @override
  Widget build(BuildContext context) {
    final next = nextTitle;
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 28),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  end: const Offset(1, 1),
                  duration: 380.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 18),
            const Text(
              'Exercise Complete!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textLight,
              ),
            ),
            if (next != null && next.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SizedBox(
                width: double.infinity,
                child: Divider(height: 1, color: Color(0xFFF1F1F1)),
              ),
              const SizedBox(height: 14),
              const Text(
                'UP NEXT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                next,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
