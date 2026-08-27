import 'dart:async';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/get_ready_screen.dart';
import 'package:fitness_app/features/player/views/workout_paused_screen.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Exercise player — Figma 11:1235.
///
/// Shared by every flow that can start a workout. Push it with a
/// [PlayerSession]; it pops a [PlayerOutcome].
class ExercisePlayerScreen extends StatefulWidget {
  final PlayerSession session;

  const ExercisePlayerScreen({super.key, required this.session});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  late int _index;
  late int _remaining;
  Timer? _ticker;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _index = widget.session.startIndex;
    _remaining = _durationFor(_index);
    // The design opens on "Get Ready!" before the first exercise runs.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showGetReady());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  int _durationFor(int index) {
    final secs = widget.session.exerciseAt(index).durationSeconds;
    return secs > 0 ? secs : 35;
  }

  String _format(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  Future<void> _showGetReady() async {
    if (widget.session.isEmpty) return;
    await context.push(
      GetReadyScreen(
        exercise: widget.session.exerciseAt(_index),
        onSkip: () => Navigator.of(context).pop(),
      ),
    );
    if (mounted) _start();
  }

  void _start() {
    _ticker?.cancel();
    setState(() => _running = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 1) {
        _next();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    if (mounted) setState(() => _running = false);
  }

  void _seek(int delta) {
    final target = _index + delta;
    if (target < 0 || target >= widget.session.length) return;
    setState(() {
      _index = target;
      _remaining = _durationFor(target);
    });
    if (_running) _start();
  }

  void _next() {
    if (_index + 1 >= widget.session.length) {
      _stop();
      Navigator.of(context).pop(PlayerOutcome.completed);
      return;
    }
    _seek(1);
  }

  /// The design has no pause glyph — tapping the transport opens the paused
  /// screen (11:1312), which is the designed pause state.
  Future<void> _openPaused() async {
    _stop();
    final outcome = await context.push<PlayerOutcome>(
      const WorkoutPausedScreen(),
    );
    if (!mounted) return;

    switch (outcome) {
      case PlayerOutcome.restart:
        setState(() {
          _index = 0;
          _remaining = _durationFor(0);
        });
        _start();
      case PlayerOutcome.later:
        Navigator.of(context).pop(PlayerOutcome.later);
      case PlayerOutcome.exited:
      case PlayerOutcome.completed:
      case null:
        _start();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.session.isEmpty) {
      return const PlayerScaffold(child: SizedBox.shrink());
    }

    final exercise = widget.session.exerciseAt(_index);
    final total = _durationFor(_index);
    final progress = total == 0 ? 0.0 : (total - _remaining) / total;

    return PlayerScaffold(
      onBack: _openPaused,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PlayerSheet(
                child: Column(
                  children: [
                    const SizedBox(height: 39),

                    // Countdown (11:1256)
                    Text(
                      _format(_remaining),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 29.12,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        exercise.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.125,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // Progress bar (11:1269) — 305x10, r130
                    const SizedBox(height: 21),
                    SizedBox(
                      width: 305,
                      height: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(130),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 10,
                          backgroundColor: AppColors.primaryLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    // Transport (11:1292)
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.only(left: 28, right: 21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _TransportButton(
                            asset: 'assets/svgs/player_skip.svg',
                            width: 17.23,
                            height: 14.6797,
                            quarterTurns: 2,
                            onTap: () => _seek(-1),
                          ),
                          _TransportButton(
                            asset: 'assets/svgs/player_play.svg',
                            width: 17.5125,
                            height: 18.5468,
                            onTap: _openPaused,
                          ),
                          _TransportButton(
                            asset: 'assets/svgs/player_skip.svg',
                            width: 17.23,
                            height: 14.6797,
                            onTap: _next,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // "1/7" (11:1297)
            const SizedBox(height: 22),
            Text(
              widget.session.positionLabel(_index),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

/// A 24x24 tap target holding one exported glyph at its designed size.
class _TransportButton extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final int quarterTurns;
  final VoidCallback onTap;

  const _TransportButton({
    required this.asset,
    required this.width,
    required this.height,
    this.quarterTurns = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget glyph = SvgPicture.asset(asset, width: width, height: height);
    if (quarterTurns != 0) {
      glyph = RotatedBox(quarterTurns: quarterTurns, child: glyph);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(width: 24, height: 24, child: Center(child: glyph)),
    );
  }
}
