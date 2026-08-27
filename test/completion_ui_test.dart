import 'package:fitness_app/features/player/views/workout_complete_screen.dart';
import 'package:fitness_app/features/player/widgets/exercise_complete_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('the exercise-complete overlay names the exercise and self-dismisses', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showExerciseCompleteOverlay(
              context,
              exerciseTitle: 'Pilates Glute Bridge',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Exercise Complete!'), findsOneWidget);
    expect(find.text('Pilates Glute Bridge'), findsOneWidget);

    // It dismisses on its own after ~1.1s, with no tap required.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    expect(find.text('Exercise Complete!'), findsNothing);
  });

  testWidgets('the workout-complete screen shows real stats and a working Done button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => const WorkoutCompleteScreen(
              planTitle: 'Pilates Premier',
              dayTitle: 'Day 2',
              exercisesCompleted: 7,
              exercisesTotal: 7,
              durationSeconds: 253,
              calories: 34,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    expect(find.text('Workout Complete!'), findsOneWidget);
    expect(find.text('Day 2 · Pilates Premier'), findsOneWidget);
    expect(find.text('04:13'), findsOneWidget, reason: '253 seconds');
    expect(find.text('34'), findsOneWidget);
    expect(find.text('7/7'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Workout Complete!'), findsNothing);
  });

  testWidgets('the workout-complete screen fits a small phone without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: WorkoutCompleteScreen(
          planTitle: 'Flat Belly Challenge',
          dayTitle: 'Week 3, Day 5',
          exercisesCompleted: 13,
          exercisesTotal: 13,
          durationSeconds: 725,
          calories: 96,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);

    // Let the confetti overlay's own timers run out so none are left
    // pending when the test tears the widget tree down.
    await tester.pump(const Duration(seconds: 8));
  });
}
