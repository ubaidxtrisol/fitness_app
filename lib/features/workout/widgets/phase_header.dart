import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// "Phase 1 · Gentle Beginning" with the completion pill on the right.
///
/// Figma 11:767 (program) / 11:909 (day). The pill (11:763) is 42x19, r10.884,
/// `#fdecec`, holding the 13x13 ring and the percentage in `Color 1`.
class PhaseHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  /// Omit to render the header without the pill — Figma 11:806 does this for
  /// the second phase on the program screen.
  final int? progressPercent;

  const PhaseHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (progressPercent != null)
          Container(
            width: 42,
            height: 19,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFDECEC),
              borderRadius: BorderRadius.circular(10.884),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svgs/progress_ring.svg',
                  width: 13,
                  height: 13,
                ),
                const SizedBox(width: 3),
                Text(
                  '$progressPercent%',
                  style: const TextStyle(
                    fontSize: 8.88,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
