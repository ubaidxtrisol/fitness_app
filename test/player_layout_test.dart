import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/views/get_ready_screen.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cover for the player chrome the exercise player shares with the ready
/// screen. The player itself reads the database in initState, and Drift's
/// futures complete on real timers that testWidgets' fake clock never
/// advances, so it is exercised through GetReadyScreen instead.
ExerciseModel get _exercise => const ExerciseModel(
  order: 1,
  exerciseId: 'ex_glute_bridge',
  title: 'Glute Bridge',
  description: '',
  durationSeconds: 35,
  reps: 0,
  restSeconds: 0,
  thumbnailUrl: '',
  videoUrl: '',
  howToDo: [],
  commonMistakes: [],
  breathingTips: [],
);

void main() {
  testWidgets('the ready screen fits the designed frame with the banner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: GetReadyScreen(
          exercise: _exercise,
          countdownSeconds: 5,
          onSkip: () {},
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(VideoBanner), findsOneWidget);
    expect(find.text('Glute Bridge'), findsOneWidget);
    expect(find.text('5'), findsOneWidget, reason: 'the configured countdown');

    // The banner may not take more than the height it was capped at.
    final banner = tester.getSize(find.byType(VideoBanner));
    expect(banner.height, lessThanOrEqualTo(852 * 0.36 + 1));

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('4'), findsOneWidget, reason: 'the countdown ticks down');

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a countdown of zero hands straight over to the player', (
    tester,
  ) async {
    var skipped = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: GetReadyScreen(
          exercise: _exercise,
          countdownSeconds: 0,
          onSkip: () => skipped++,
        ),
      ),
    );
    await tester.pump();

    expect(skipped, 1, reason: 'no countdown means no waiting');
  });

  testWidgets('the ready screen still fits a short phone', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: GetReadyScreen(
          exercise: _exercise,
          countdownSeconds: 0,
          onSkip: () {},
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
