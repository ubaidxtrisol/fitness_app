import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The weekly/monthly/yearly bar chart — Figma 16:819 (Duration selected) and
/// 17:1234 (Calories selected).
///
/// 361x340, r16. The track is 175pt tall from the top gridline down to the
/// #4D4D4D baseline; bars are 8pt wide with a #FF0C53 -> #E45881 gradient over
/// a #FEEFF2 rail.
class ProgressChartCard extends StatelessWidget {
  final ChartSeries series;

  /// True while the Duration tab is selected (Figma 16:418), false for
  /// Calories (17:1159).
  final bool showingDuration;
  final ProgressPeriod period;
  final ValueChanged<bool> onTabChanged;
  final ValueChanged<ProgressPeriod> onPeriodChanged;

  const ProgressChartCard({
    super.key,
    required this.series,
    required this.showingDuration,
    required this.period,
    required this.onTabChanged,
    required this.onPeriodChanged,
  });

  static const double _trackHeight = 175;
  static const double _axisWidth = 25;
  static const double _axisGap = 14;

  /// The axis tops out at the week's peak rounded up to a tidy step — real
  /// minutes and calories are nothing like the design's 0-5 range.
  double get _maxValue {
    final peak = series.peak;
    return peak <= 0 ? 5 : (peak / 5).ceil() * 5;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 11, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header: "Duration (min)" + the period pill (16:1099).
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: showingDuration ? 'Duration' : 'Calories',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: showingDuration ? ' (min)' : ' (kcal)',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              _PeriodPill(period: period, onChanged: onPeriodChanged),
            ],
          ),

          22.heightBox,

          // Y axis + bars.
          SizedBox(
            height: _trackHeight,
            child: Row(
              children: [
                SizedBox(
                  width: _axisWidth,
                  child: _YAxis(maxValue: _maxValue),
                ),
                _axisGap.widthBox,
                Expanded(
                  child: _Bars(values: series.values, maxValue: _maxValue),
                ),
              ],
            ),
          ),

          // Baseline (16:1027).
          Row(
            children: [
              const SizedBox(width: _axisWidth + _axisGap),
              const Expanded(
                child: SizedBox(
                  height: 1,
                  child: ColoredBox(color: AppColors.textLight),
                ),
              ),
            ],
          ),

          11.heightBox,

          Row(
            children: [
              const SizedBox(width: _axisWidth + _axisGap),
              Expanded(
                child: _XAxis(
                  labels: series.labels,
                  count: series.values.length,
                ),
              ),
            ],
          ),

          23.heightBox,

          _TabSwitcher(
            showingDuration: showingDuration,
            onChanged: onTabChanged,
          ),
        ],
      ),
    );
  }
}

/// Six evenly spaced labels from the peak down to zero — Figma 16:941.
class _YAxis extends StatelessWidget {
  final double maxValue;

  const _YAxis({required this.maxValue});

  static const int _steps = 5;
  static const double _lineHeight = 16;

  @override
  Widget build(BuildContext context) {
    const step = ProgressChartCard._trackHeight / _steps;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (var i = 0; i <= _steps; i++)
          Positioned(
            top: i * step - _lineHeight / 2,
            right: 0,
            width: ProgressChartCard._axisWidth,
            height: _lineHeight,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(maxValue - (maxValue / _steps) * i).round()}',
                style: const TextStyle(
                  fontSize: 12.723,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// The candle bars themselves — Figma 16:971.
class _Bars extends StatelessWidget {
  final List<double> values;
  final double maxValue;

  const _Bars({required this.values, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 8pt is the designed width; a 31-day month has to give some back.
        final barWidth = (constraints.maxWidth / values.length * 0.8)
            .clamp(2.0, 8.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final value in values)
              SizedBox(
                width: barWidth,
                height: ProgressChartCard._trackHeight,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    SizedBox(
                      width: barWidth,
                      height:
                          ProgressChartCard._trackHeight *
                          (maxValue <= 0 ? 0.0 : value / maxValue).clamp(
                            0.0,
                            1.0,
                          ),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primaryDark,
                              AppColors.primary,
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Bucket labels under the bars — Figma 16:951 onwards.
class _XAxis extends StatelessWidget {
  final List<String> labels;
  final int count;

  const _XAxis({required this.labels, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox(height: 16);

    // A month's worth of buckets needs a smaller label than a week's.
    final fontSize = count > 14 ? 9.0 : 12.723;

    return LayoutBuilder(
      builder: (context, constraints) {
        final slot = (constraints.maxWidth / count * 0.8).clamp(2.0, 8.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < count; i++)
              SizedBox(
                width: slot,
                height: 16,
                child: OverflowBox(
                  maxWidth: 40,
                  child: Text(
                    i < labels.length ? labels[i] : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// The period dropdown — Figma 16:1099. 96x28, r9, 0.5pt #F4F4F4 border.
class _PeriodPill extends StatelessWidget {
  final ProgressPeriod period;
  final ValueChanged<ProgressPeriod> onChanged;

  const _PeriodPill({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProgressPeriod>(
      initialValue: period,
      onSelected: onChanged,
      tooltip: 'Change period',
      position: PopupMenuPosition.under,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        for (final option in ProgressPeriod.values)
          PopupMenuItem<ProgressPeriod>(
            value: option,
            height: 40,
            child: Text(
              option.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: option == period
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: option == period
                    ? AppColors.primary
                    : AppColors.textLight,
              ),
            ),
          ),
      ],
      child: Container(
        width: 96,
        height: 28,
        padding: const EdgeInsets.only(left: 9, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFF4F4F4), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/calendar.svg',
                  width: 11.375,
                  height: 12.542,
                ),
              ),
            ),
            6.widthBox,
            Expanded(
              child: Text(
                period.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            6.widthBox,
            SvgPicture.asset(
              'assets/svgs/chevron_down.svg',
              width: 14,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// Duration / Calories segmented control — Figma 17:1156 and 17:1358.
///
/// A centred pill that hugs its two 34pt segments rather than filling the
/// card's width.
class _TabSwitcher extends StatelessWidget {
  final bool showingDuration;
  final ValueChanged<bool> onChanged;

  const _TabSwitcher({required this.showingDuration, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(color: Color(0x8CCCCCCC), blurRadius: 1),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Segment(
              label: 'Duration',
              svgPath: 'assets/svgs/toggle_clock.svg',
              iconWidth: 12.849,
              iconHeight: 12.849,
              active: showingDuration,
              onTap: () => onChanged(true),
            ),
            17.widthBox,
            _Segment(
              label: 'Calories',
              svgPath: 'assets/svgs/toggle_flame.svg',
              iconWidth: 9.743,
              iconHeight: 12.4,
              active: !showingDuration,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final String svgPath;
  final double iconWidth;
  final double iconHeight;
  final bool active;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.svgPath,
    required this.iconWidth,
    required this.iconHeight,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = active ? Colors.white : AppColors.textLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 98,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: iconWidth,
              height: iconHeight,
              colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
            ),
            5.widthBox,
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
