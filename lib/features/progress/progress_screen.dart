import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/progress/views/history_view.dart';
import 'package:fitness_app/features/progress/widgets/delete_session_dialog.dart';
import 'package:fitness_app/features/progress/widgets/history_card.dart';
import 'package:fitness_app/features/progress/widgets/history_month_card.dart';
import 'package:fitness_app/features/progress/widgets/progress_chart_card.dart';
import 'package:fitness_app/features/progress/widgets/progress_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Figma 16:418 (Duration selected) / 17:1159 (Calories selected).
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  /// How many of the newest month's workouts the Progress screen itself shows;
  /// the rest live behind "See All".
  static const int _previewCount = 3;

  final ProgressRepository _progress = ProgressRepository();

  bool _showingDuration = true;
  ProgressPeriod _period = ProgressPeriod.thisWeek;

  ProgressSummary _summary = ProgressSummary.empty;
  ChartSeries _duration = ChartSeries.empty;
  ChartSeries _calories = ChartSeries.empty;
  List<SessionLog> _history = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final summary = await _progress.lifetimeSummary();
    final duration = await _progress.chartSeries(_period, minutes: true);
    final calories = await _progress.chartSeries(_period, minutes: false);
    final history = await _progress.recentSessions(limit: 20);
    if (!mounted) return;

    setState(() {
      _summary = summary;
      _duration = duration;
      _calories = calories;
      _history = history;
      _loading = false;
    });
  }

  Future<void> _changePeriod(ProgressPeriod period) async {
    if (period == _period) return;
    setState(() => _period = period);

    final duration = await _progress.chartSeries(period, minutes: true);
    final calories = await _progress.chartSeries(period, minutes: false);
    if (!mounted) return;

    setState(() {
      _duration = duration;
      _calories = calories;
    });
  }

  Future<void> _deleteSession(SessionLog log) async {
    final confirmed = await confirmSessionDelete(context, log);
    if (!confirmed) return;

    await _progress.deleteSession(log.id);
    await _load();
  }

  /// The newest month that has anything in it, capped at [_previewCount].
  MapEntry<String, List<SessionLog>>? get _previewMonth {
    final months = groupSessionsByMonth(_history);
    if (months.isEmpty) return null;

    final newest = months.first;
    return MapEntry(newest.key, newest.value.take(_previewCount).toList());
  }

  @override
  Widget build(BuildContext context) {
    final month = _previewMonth;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),

              18.heightBox,

              ProgressStatsCard(summary: _summary),

              11.heightBox,

              ProgressChartCard(
                series: _showingDuration ? _duration : _calories,
                showingDuration: _showingDuration,
                period: _period,
                onTabChanged: (duration) =>
                    setState(() => _showingDuration = duration),
                onPeriodChanged: _changePeriod,
              ),

              12.heightBox,

              HistoryMonthCard(
                title: month?.key ?? SessionFormat.monthTitle(DateTime.now()),
                sessions: month?.value ?? const [],
                onSeeAll: () async {
                  await context.push(const HistoryView());
                  await _load();
                },
                onDelete: _deleteSession,
                placeholder: _loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : const _EmptyHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Menu tile, greeting and bell — Figma 16:494.
  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: const [
                BoxShadow(color: Color(0x17000000), blurRadius: 3),
              ],
            ),
            child: SvgPicture.asset(
              'assets/svgs/menu.svg',
              width: 22,
              height: 16,
            ),
          ),
        ),

        7.widthBox,

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning Emily',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Let's continue your wellness journey",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6C434C),
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 26,
            height: 26,
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/notifications.svg',
                width: 16,
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shown in place of the rows before the first workout is logged.
class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'No workouts logged yet.\nFinish a session and it will show up here.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textLight,
          height: 1.5,
        ),
      ),
    );
  }
}
