import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The 76-tall white row used by both workout screens.
///
/// Two variants ship in the design:
/// * [WorkoutRowCard.day] — Figma 11:766: a 115x76 thumbnail, an `01` badge and
///   a bold title.
/// * [WorkoutRowCard.exercise] — Figma 11:898: a 76x76 thumbnail, no badge and
///   a regular-weight title.
class WorkoutRowCard extends StatelessWidget {
  static const double height = 76;

  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final double thumbnailWidth;
  final double thumbnailRadius;
  final String? badgeLabel;
  final double contentLeft;
  final double contentTop;
  final double contentGap;
  final FontWeight titleWeight;
  final Color titleColor;
  final VoidCallback? onTap;

  /// Shows a small green checkmark badge over the thumbnail's top-right
  /// corner — Requirement: an exercise already logged this run (or every
  /// exercise, once the whole day is done) reads as complete at a glance.
  final bool isDone;

  /// Figma 11:766 — day row on the program screen.
  const WorkoutRowCard.day({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required String badge,
    this.onTap,
    this.isDone = false,
  }) : badgeLabel = badge,
       thumbnailWidth = 115,
       thumbnailRadius = 16,
       contentLeft = 125,
       contentTop = 20,
       contentGap = 9,
       titleWeight = FontWeight.w700,
       titleColor = AppColors.textLight;

  /// Figma 11:898 — exercise row on the day screen.
  const WorkoutRowCard.exercise({
    super.key,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    this.onTap,
    this.isDone = false,
  }) : badgeLabel = null,
       thumbnailWidth = 76,
       thumbnailRadius = 13,
       contentLeft = 84,
       contentTop = 14,
       contentGap = 4,
       titleWeight = FontWeight.w400,
       titleColor = AppColors.textPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Thumbnail
            Positioned(
              left: 0,
              top: 0,
              width: thumbnailWidth,
              height: height,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(thumbnailRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: thumbnailUrl.isEmpty
                    ? null
                    : Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
              ),
            ),

            // Completed checkmark — anchored to the thumbnail's own corner so
            // it lands in the same spot regardless of which variant this is.
            if (isDone)
              Positioned(
                left: thumbnailWidth - 18,
                top: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 2)],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),

            // Order badge (day rows only)
            if (badgeLabel != null)
              Positioned(
                left: 6,
                top: 5,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeLabel!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),

            // Title + subtitle
            Positioned(
              left: contentLeft,
              top: contentTop,
              right: 53,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: titleWeight,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: contentGap),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing arrow pill
            Positioned(
              right: 11,
              top: 23,
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
    );
  }
}
