import 'dart:async';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Same banner the player uses, so the hand-off is seamless.
              VideoBanner(
                controller: widget.controller,
                isReady: widget.isVideoReady,
                maxHeight: MediaQuery.sizeOf(context).height * 0.36,
              ),
              const SizedBox(height: 16),
              PlayerSheet(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 39, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Heading block (11:1220) — shows the live count once the
                      // countdown is running.
                      Text(
                        _remaining > 0 ? '$_remaining' : 'Get Ready!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 29.12,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 17),
                      Text(
                        widget.exercise.title,
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
                      const SizedBox(height: 3),
                      const Text(
                        'Start Your Practice Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Skip button (11:1223) with its trailing arrow pill.
                      GestureDetector(
                        onTap: () {
                          _ticker?.cancel();
                          widget.onSkip();
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Stack(
                            children: [
                              const Center(
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.surface,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 11,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svgs/arrow_right.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
