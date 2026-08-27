import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/progress/widgets/history_card.dart';
import 'package:fitness_app/features/progress/widgets/history_month_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget-level cover for the history surfaces (Figma 17:1630 / 17:1688).
///
/// Data is handed in directly — Drift's futures complete on real timers that
/// testWidgets' fake clock never advances, so DB assertions live in the plain
/// `test()` cases in progress_tracking_test.dart.
SessionLog _log({
  int id = 1,
  String planTitle = 'Pilates Premier',
  String dayTitle = 'Day 2',
  String dayLevel = 'Beginner',
  int durationSeconds = 253,
  int calories = 31,
  String thumbnailUrl = '',
  DateTime? completedAt,
}) {
  final at = completedAt ?? DateTime(2026, 8, 12, 16, 13);
  return SessionLog(
    id: id,
    planId: 'p1',
    planType: PlanType.program,
    planTitle: planTitle,
    dayId: 'd$id',
    dayTitle: dayTitle,
    dayLevel: dayLevel,
    dayIndex: 1,
    exercisesCompleted: 7,
    exercisesTotal: 7,
    durationSeconds: durationSeconds,
    calories: calories,
    completed: true,
    thumbnailUrl: thumbnailUrl,
    startedAt: at.subtract(const Duration(minutes: 4)),
    completedAt: at,
  );
}

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: SizedBox(width: 336, child: child)));

void main() {
  testWidgets('a history card renders the logged run, not placeholders', (
    tester,
  ) async {
    await tester.pumpWidget(_host(HistoryCard(log: _log())));

    expect(find.text('Pilates Premier'), findsOneWidget);
    expect(find.text('Day 2. Beginner'), findsOneWidget);
    expect(find.text('04:13 PM'), findsOneWidget);
    expect(find.text('AUG 12'), findsOneWidget);
    expect(find.text('04:13'), findsOneWidget, reason: '253s duration');
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
    expect(find.text('Kcal'), findsOneWidget);
  });

  testWidgets('a log with no level falls back to the day title alone', (
    tester,
  ) async {
    await tester.pumpWidget(_host(HistoryCard(log: _log(dayLevel: ''))));

    expect(find.text('Day 2'), findsOneWidget);
  });

  testWidgets('See All only shows where there is somewhere to go', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        HistoryMonthCard(title: 'August 2026', sessions: [_log()]),
      ),
    );
    expect(find.text('See All'), findsNothing);

    await tester.pumpWidget(
      _host(
        HistoryMonthCard(
          title: 'August 2026',
          sessions: [_log()],
          onSeeAll: () {},
        ),
      ),
    );
    expect(find.text('August 2026'), findsOneWidget);
    expect(find.text('See All'), findsOneWidget);
  });

  testWidgets('an empty month shows its placeholder instead of rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const HistoryMonthCard(
          title: 'August 2026',
          sessions: [],
          placeholder: Text('No workouts logged yet.'),
        ),
      ),
    );

    expect(find.text('No workouts logged yet.'), findsOneWidget);
    expect(find.byType(HistoryCard), findsNothing);
  });

  test('months group newest first and sort inside themselves', () {
    final months = groupSessionsByMonth([
      _log(id: 1, completedAt: DateTime(2026, 8, 2, 7)),
      _log(id: 2, completedAt: DateTime(2026, 7, 4, 8)),
      _log(id: 3, completedAt: DateTime(2026, 8, 12, 16)),
    ]);

    expect(months.map((m) => m.key).toList(), ['August 2026', 'July 2026']);
    expect(months.first.value.map((s) => s.id).toList(), [3, 1]);
  });

  test('session formatting matches the designed labels', () {
    expect(SessionFormat.clock(DateTime(2026, 8, 12, 16, 13)), '04:13 PM');
    expect(SessionFormat.clock(DateTime(2026, 8, 12, 0, 5)), '12:05 AM');
    expect(SessionFormat.shortDate(DateTime(2026, 8, 12)), 'AUG 12');
    expect(SessionFormat.duration(253), '04:13');
    expect(SessionFormat.monthTitle(DateTime(2026, 8, 12)), 'August 2026');
  });
}
