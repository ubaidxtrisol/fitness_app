import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/home/widgets/home_hero_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pump();
  }

  testWidgets('banner falls back cleanly before any progress exists', (
    tester,
  ) async {
    await pump(tester, const HomeHeroBanner());
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);
    expect(find.text('6min/7 Exercise'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a fresh plan reads as a start', (tester) async {
    await pump(
      tester,
      const HomeHeroBanner(
        nextUp: NextUpSuggestion(
          planId: 'p',
          planType: PlanType.program,
          planTitle: 'Pilates Premier',
          dayTitle: 'Day 1',
          dayIndex: 0,
          totalDays: 3,
          exerciseCount: 7,
          durationMinutes: 5,
          isResuming: false,
        ),
      ),
    );
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);
    expect(find.text('5min/7 Exercise'), findsOneWidget);
    expect(find.textContaining('Move Better'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a resumed plan names the day and offers Continue', (
    tester,
  ) async {
    await pump(
      tester,
      const HomeHeroBanner(
        nextUp: NextUpSuggestion(
          planId: 'p',
          planType: PlanType.program,
          planTitle: 'Pilates Premier',
          dayTitle: 'Day 3',
          dayIndex: 2,
          totalDays: 3,
          exerciseCount: 10,
          durationMinutes: 7,
          isResuming: true,
        ),
      ),
    );
    expect(find.text('Day 3'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('7min/10 Exercise'), findsOneWidget);
    expect(find.textContaining('Keep Going'), findsOneWidget);
    expect(find.textContaining('Day 3 of 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a long plan name does not overflow the banner', (tester) async {
    await pump(
      tester,
      const HomeHeroBanner(
        nextUp: NextUpSuggestion(
          planId: 'p',
          planType: PlanType.challenge,
          planTitle: 'An Extremely Long Challenge Name That Should Truncate',
          dayTitle: 'Day 12',
          dayIndex: 11,
          totalDays: 28,
          exerciseCount: 13,
          durationMinutes: 25,
          isResuming: true,
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
