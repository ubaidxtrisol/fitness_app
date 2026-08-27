import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Lifetime totals strip — Figma 16:848.
///
/// 361x74, r13. Each item is a 26pt r13 chip over a value/label pair; the
/// chip's tint is baked into the exported SVG (#FEEFF2 / #F0F6FE / #EEF9EF /
/// #FFF3EA), so the icons are drawn at their designed 26pt.
class ProgressStatsCard extends StatelessWidget {
  final ProgressSummary summary;

  const ProgressStatsCard({super.key, required this.summary});

  static String _two(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.fromLTRB(20, 11, 16, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              svgPath: 'assets/svgs/fire.svg',
              value: '${summary.calories}',
              label: 'Calories',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _StatItem(
              svgPath: 'assets/svgs/history.svg',
              value: '${summary.minutes}',
              label: 'Minutes',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _StatItem(
              svgPath: 'assets/svgs/check.svg',
              value: _two(summary.workouts),
              label: 'Workout',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _StatItem(
              svgPath: 'assets/svgs/stars.svg',
              value: _two(summary.streakDays),
              label: 'Day Streak',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String svgPath;
  final String value;
  final String label;

  const _StatItem({
    required this.svgPath,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(svgPath, width: 26, height: 26),
        6.heightBox,
        Text(
          value,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 8.143,
            fontWeight: FontWeight.w700,
            height: 1.15,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 8.143,
            fontWeight: FontWeight.w400,
            height: 1.15,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// The 47pt hairline between items — Figma 16:860 (#DADADA, 0.6 wide).
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 0.6,
      height: 47,
      child: ColoredBox(color: AppColors.borderDark),
    );
  }
}
