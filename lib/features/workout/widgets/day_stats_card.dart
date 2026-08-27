import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Level / Calories / Net Duration strip — Figma 11:852.
///
/// One 361x70 white card (r13) holding three stats separated by 0.6x47 rules.
class DayStatsCard extends StatelessWidget {
  static const double _labelSize = 8.143;

  final DayModel day;

  /// Figma 11:738 leads with the difficulty ("Beginner" / "Level"); the
  /// challenge day screen (12:2352) leads with the week ("01" / "Week").
  final String? leadingTitle;
  final String? leadingSubtitle;

  const DayStatsCard({
    super.key,
    required this.day,
    this.leadingTitle,
    this.leadingSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _Stat(
              asset: 'assets/svgs/stat_level.svg',
              iconSize: 16,
              iconPadding: 5,
              iconBackground: const Color(0xFFEEF9EF),
              title: leadingTitle ?? day.difficulty,
              subtitle: leadingSubtitle ?? 'Level',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _Stat(
              asset: 'assets/svgs/stat_calories.svg',
              iconSize: 16,
              iconPadding: 5,
              iconBackground: AppColors.primaryLight,
              title: '${day.caloriesBurned}',
              subtitle: 'Calories',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _Stat(
              asset: 'assets/svgs/stat_duration.svg',
              iconSize: 14,
              iconPadding: 6,
              iconBackground: const Color(0xFFF0F6FE),
              title: '${day.netTimeMinutes} min',
              subtitle: 'Net Duration',
            ),
          ),
        ],
      ),
    );
  }
}

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

class _Stat extends StatelessWidget {
  final String asset;
  final double iconSize;
  final double iconPadding;
  final Color iconBackground;
  final String title;
  final String subtitle;

  const _Stat({
    required this.asset,
    required this.iconSize,
    required this.iconPadding,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(13),
          ),
          child: SvgPicture.asset(asset, width: iconSize, height: iconSize),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: DayStatsCard._labelSize,
            height: 1,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: DayStatsCard._labelSize,
            height: 1,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
