import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/material.dart';

/// Workout card — the Discover rail draws it 224 wide (node 15:1121); the Body
/// Focus grid draws the same card 172.256 wide with a 147.413 image (node
/// 14:24). Pass [width] / [imageHeight] / [margin] to switch between them.
class DiscoverWorkoutCard extends StatelessWidget {
  /// Figma 14:24 — one grid cell on the Body Focus category screen.
  static const double gridWidth = 172.256;
  static const double gridHeight = 216.463;
  static const double gridImageHeight = 147.413;

  final WorkoutModel workout;
  final double width;
  final double height;
  final double imageHeight;
  final EdgeInsets margin;
  final VoidCallback? onTap;

  const DiscoverWorkoutCard({
    super.key,
    required this.workout,
    this.width = 224,
    this.height = 216,
    this.imageHeight = 167.5,
    this.margin = const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 1.91,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Rounded Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: .circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                workout.thumbnailUrl,
                fit: BoxFit.cover,
                height: imageHeight,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFF3F4F6),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 32,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Card Text Details — Expanded + Flexible so a two-line title can
            // never push past the card's fixed height (Figma 14:24 leaves
            // 216.463 - 147.413 for this block).
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        workout.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    6.heightBox,
                    Row(
                      children: [
                        Text(
                          workout.difficulty,
                          style: const TextStyle(
                            fontSize: 11.59,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        6.widthBox,
                        Text(
                          '${workout.durationMinutes}min',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
