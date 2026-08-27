import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// "Get Ready!" — Figma 11:1201.
///
/// Full-bleed model artwork with a 361x210 sheet pinned near the bottom.
class GetReadyScreen extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onSkip;

  const GetReadyScreen({
    super.key,
    required this.exercise,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return PlayerScaffold(
      // Node 11:1296 rotates the landscape source -90 to fill the portrait area.
      backdrop: const RotatedBox(
        quarterTurns: 3,
        child: Image(
          image: AssetImage('assets/images/player_model.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PlayerSheet(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 39, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Heading block (11:1220)
                      const Text(
                        'Get Ready!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 29.12,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        exercise.title,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
