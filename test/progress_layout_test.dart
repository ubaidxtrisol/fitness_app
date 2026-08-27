import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/progress/widgets/history_card.dart';
import 'package:fitness_app/features/progress/widgets/history_month_card.dart';
import 'package:fitness_app/features/progress/widgets/progress_chart_card.dart';
import 'package:fitness_app/features/progress/widgets/progress_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Layout cover for the Progress screen's Figma geometry (16:418).
///
/// Renders the three panels at the designed 393x852 frame and fails on any
/// RenderFlex overflow — the stats strip and the 31-bar month chart are both
/// tight enough to break under small edits.

SessionLog log(int id, DateTime at) => SessionLog(
  id: id,
  planId: 'p1',
  planType: PlanType.program,
  planTitle: 'Pilates Premier',
  dayId: 'd$id',
  dayTitle: 'Day $id',
  dayLevel: 'Intermediate',
  dayIndex: id,
  exercisesCompleted: 7,
  exercisesTotal: 7,
  durationSeconds: 253,
  calories: 31,
  completed: true,
  thumbnailUrl: '',
  startedAt: at,
  completedAt: at,
);

void main() {
  for (final period in ProgressPeriod.values) {
    testWidgets('no overflow at 393x852 — $period', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final count = switch (period) {
        ProgressPeriod.thisWeek => 7,
        ProgressPeriod.thisMonth => 31,
        ProgressPeriod.thisYear => 12,
      };
      final series = ChartSeries(
        values: List.generate(count, (i) => (i % 5) * 7.0),
        labels: List.generate(
          count,
          (i) => count > 14
              ? (i == 0 || (i + 1) % 5 == 0 ? '${i + 1}' : '')
              : 'M',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                children: [
                  const ProgressStatsCard(
                    summary: ProgressSummary(
                      calories: 2345,
                      minutes: 1250,
                      workouts: 44,
                      streakDays: 6,
                    ),
                  ),
                  const SizedBox(height: 11),
                  ProgressChartCard(
                    series: series,
                    showingDuration: true,
                    period: period,
                    onTabChanged: (_) {},
                    onPeriodChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  HistoryMonthCard(
                    title: 'August 2026',
                    sessions: [
                      log(1, DateTime(2026, 8, 12, 16, 13)),
                      log(2, DateTime(2026, 8, 11, 6, 3)),
                    ],
                    onSeeAll: () {},
                    onDelete: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester.takeException(),
        isNull,
        reason: 'the Figma geometry must not overflow on a 393pt frame',
      );

      // Figma: stats 361x74 (16:848), history row 336x68 (17:1630). Widths
      // are exact; the chart card's height moves with the label metrics of
      // whichever font the harness substitutes.
      expect(tester.getSize(find.byType(ProgressStatsCard)), const Size(361, 74));
      expect(tester.getSize(find.byType(HistoryCard).first).height, 68);
      expect(tester.getSize(find.byType(ProgressChartCard)).width, 361);
    });
  }
}
