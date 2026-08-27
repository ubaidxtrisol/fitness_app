import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// "Week 1 · Belly Action" plus its day chips — Figma 12:1937.
///
/// Eight 32x32 slots (days 1-7 then the trophy) separated by small chevrons.
/// The design pitches them 46.86 apart across 360; here they are distributed so
/// the row fits any width, keeping the chip size fixed.
class WeekTrack extends StatelessWidget {
  static const double chipSize = 32;

  final String title;
  final String subtitle;
  final int dayCount;

  /// Index of the day the user is on — that chip gets the `Color 1` outline.
  final int currentDayIndex;
  final void Function(int dayIndex)? onDaySelected;

  const WeekTrack({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dayCount,
    required this.currentDayIndex,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header (12:1849)
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFA32045),
              ),
            ),
            const SizedBox(width: 7),
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
        const SizedBox(height: 12),

        // Chips + separators (12:1936)
        Row(
          children: [
            for (var i = 0; i < dayCount; i++) ...[
              _DayChip(
                label: '${i + 1}',
                isCurrent: i == currentDayIndex,
                onTap: onDaySelected == null ? null : () => onDaySelected!(i),
              ),
              const _Separator(),
            ],
            const _TrophyChip(),
          ],
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SvgPicture.asset(
          'assets/svgs/week_chevron.svg',
          width: 2.09532,
          height: 4.30305,
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _DayChip({required this.label, required this.isCurrent, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: WeekTrack.chipSize,
        height: WeekTrack.chipSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isCurrent ? Border.all(color: AppColors.primary) : null,
          boxShadow: isCurrent
              ? null
              : const [BoxShadow(color: Color(0x24000000), blurRadius: 0.5)],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Color(0xFFA32045),
          ),
        ),
      ),
    );
  }
}

class _TrophyChip extends StatelessWidget {
  const _TrophyChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WeekTrack.chipSize,
      height: WeekTrack.chipSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x24000000), blurRadius: 0.5)],
      ),
      child: SvgPicture.asset(
        'assets/svgs/trophy.svg',
        width: 15.0001,
        height: 15.0001,
      ),
    );
  }
}
