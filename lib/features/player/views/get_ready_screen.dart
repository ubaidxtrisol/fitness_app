import 'dart:async';

import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/widgets/get_ready_card.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// "Get Ready!" — Figma 11:1201.
///
/// Counts down from the user's configured countdown before handing over to the
/// player. The exercise clip is already playing behind the sheet so the first
/// rep starts the instant the count hits zero.
class GetReadyScreen extends StatefulWidget {
  final ExerciseModel exercise;

  /// From workout settings; 0 skips the countdown entirely.
  final int countdownSeconds;

  /// Controller owned by the player, shown here so playback is seamless.
  final VideoPlayerController? controller;
  final bool isVideoReady;
  final VoidCallback onSkip;

  const GetReadyScreen({
    super.key,
    required this.exercise,
    required this.countdownSeconds,
    required this.onSkip,
    this.controller,
    this.isVideoReady = false,
  });

  @override
  State<GetReadyScreen> createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends State<GetReadyScreen> {
  Timer? _ticker;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.countdownSeconds;
    if (_remaining <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onSkip());
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 1) {
        _ticker?.cancel();
        widget.onSkip();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Same banner the player uses, so the hand-off is seamless.
              VideoBanner(
                controller: widget.controller,
                isReady: widget.isVideoReady,
                maxHeight: MediaQuery.sizeOf(context).height * 0.36,
              ),
              Spacer(),
              PlayerSheet(
                child: GetReadyCard(
                  remaining: _remaining,
                  exerciseTitle: widget.exercise.title,
                  onSkip: () {
                    _ticker?.cancel();
                    widget.onSkip();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
