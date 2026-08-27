import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/widgets/paused_overlay.dart';
import 'package:flutter/material.dart';

/// Paused overlay — Figma 11:1312.
///
/// The running artwork stays behind a 75% white scrim with a 2px backdrop blur;
/// three actions sit at the bottom. Pops with a [PlayerOutcome].
///
/// [ExercisePlayerScreen] no longer navigates here — it shows the same
/// [PausedOverlay] in place via `AnimatedSwitcher` so pausing never leaves the
/// exercise screen. This route stays for any other caller that wants the
/// paused state as a real screen.
class WorkoutPausedScreen extends StatelessWidget {
  const WorkoutPausedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/program_banner.png', fit: BoxFit.cover),
          PausedOverlay(
            onKeepExercising: () =>
                Navigator.of(context).pop(PlayerOutcome.exited),
            onRestart: () => Navigator.of(context).pop(PlayerOutcome.restart),
            onLater: () => Navigator.of(context).pop(PlayerOutcome.later),
          ),
        ],
      ),
    );
  }
}
