import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/workout/widgets/step_lock_dialog.dart';
import 'package:fitness_app/features/challenges/widgets/week_track.dart';
import 'package:fitness_app/features/player/widgets/resume_session_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('the lock dialog explains where the user actually is', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showStepLockedDialog(
              context,
              currentPositionLabel: 'Week 2, Day 3',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('One Step at a Time'), findsOneWidget);
    expect(find.textContaining('Week 2, Day 3'), findsOneWidget);
    expect(find.text('Got It'), findsOneWidget);

    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();
    expect(find.text('One Step at a Time'), findsNothing);
  });

  testWidgets('the lock dialog still reads sensibly with no position label', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () =>
                showStepLockedDialog(context, currentPositionLabel: ''),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.text('Finish the days before this one to unlock it.'),
      findsOneWidget,
    );
  });

  testWidgets('the resume dialog reports the real completed count and choice', (
    tester,
  ) async {
    ResumeChoice? result;

    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showResumeSessionDialog(
                context,
                completedCount: 4,
                totalCount: 7,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.textContaining('4 of 7'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(result, ResumeChoice.resume);
  });

  testWidgets('choosing Start Over reports the restart choice', (tester) async {
    ResumeChoice? result;

    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showResumeSessionDialog(
                context,
                completedCount: 2,
                totalCount: 5,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Over'));
    await tester.pumpAndSettle();

    expect(result, ResumeChoice.restart);
  });

  testWidgets('week track shows a lock glyph on locked days and a check on completed ones', (
    tester,
  ) async {
    final tapped = <int>[];

    await tester.pumpWidget(
      _host(
        WeekTrack(
          title: 'Week 1',
          subtitle: 'Belly Action',
          statuses: const [
            ChallengeDayStatus.completed,
            ChallengeDayStatus.current,
            ChallengeDayStatus.locked,
            ChallengeDayStatus.locked,
          ],
          onDaySelected: tapped.add,
        ),
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsNWidgets(2));
    // The current and completed slots render their day number; locked ones
    // show a glyph instead.
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsNothing);

    // Locked chips are still tappable — browsing ahead is allowed.
    await tester.tap(find.byIcon(Icons.lock_rounded).first);
    expect(tapped, isNotEmpty);
  });
}
