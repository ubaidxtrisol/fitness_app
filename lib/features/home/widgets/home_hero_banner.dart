import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';

class HomeHeroBanner extends StatelessWidget {
  final VoidCallback? onStartWorkout;

  const HomeHeroBanner({super.key, this.onStartWorkout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 169,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(left: 12, bottom: 12, right: 8, top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EBE8),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background right model artwork
          Positioned(
            right: 6,
            bottom: 6,
            top: 10,
            width: 196,
            child: Image.asset(
              'assets/images/home_card.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),

          // Content overlay
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF398B1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Day 1',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              4.heightBox,
              // Main Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Move Better\nFeel Stronger',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      height: 1.15,
                    ),
                  ),
                  // 6.heightBox,
                  const Text(
                    'Pilates and Yoga for a\nhealthier lifestyle',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7A686D),
                      height: 1.2,
                    ),
                  ),
                  4.heightBox,
                  const Text(
                    '6min/7 Exercise',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C434C),
                    ),
                  ),
                ],
              ),
              4.heightBox,
              // Start Workout Button with Pink Arrow
              GestureDetector(
                onTap: onStartWorkout,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Start Workout',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      6.widthBox,
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
