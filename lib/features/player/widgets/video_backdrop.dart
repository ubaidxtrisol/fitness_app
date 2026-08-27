import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Plays the exercise clip full-bleed behind the player UI.
///
/// Kept for surfaces that genuinely want an edge-to-edge fill. The player and
/// the ready screen use [VideoBanner] instead: cropping a 16:9 clip to a phone's
/// 9:19.5 frame throws away most of the exercise.
class VideoBackdrop extends StatelessWidget {
  final VideoPlayerController? controller;
  final bool isReady;
  final String fallbackAsset;

  const VideoBackdrop({
    super.key,
    required this.controller,
    required this.isReady,
    this.fallbackAsset = 'assets/images/player_model.png',
  });

  @override
  Widget build(BuildContext context) {
    if (controller == null || !isReady) {
      return Image.asset(fallbackAsset, fit: BoxFit.cover);
    }

    final size = controller!.value.size;

    // FittedBox + a natural-size SizedBox is the standard way to make a video
    // behave like BoxFit.cover; VideoPlayer alone always stretches.
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width == 0 ? 1 : size.width,
        height: size.height == 0 ? 1 : size.height,
        child: VideoPlayer(controller!),
      ),
    );
  }
}

/// The exercise clip in a rounded banner at its own aspect ratio.
///
/// The banner takes the full width it is given and derives its height from the
/// clip, so nothing is cropped; [maxHeight] caps it so a portrait clip cannot
/// push the player sheet off-screen, and the banner narrows to keep the ratio
/// when that cap bites. Falls back to the bundled artwork until the clip is
/// ready.
class VideoBanner extends StatelessWidget {
  final VideoPlayerController? controller;
  final bool isReady;
  final String fallbackAsset;
  final double maxHeight;
  final double borderRadius;

  const VideoBanner({
    super.key,
    required this.controller,
    required this.isReady,
    this.fallbackAsset = 'assets/images/player_model.png',
    this.maxHeight = 320,
    this.borderRadius = 26,
  });

  /// 16:9 until the clip reports otherwise, so the banner does not jump size
  /// when playback starts.
  static const double _defaultRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final player = controller;
    final ready = player != null && isReady;
    final reported = ready ? player.value.aspectRatio : 0.0;
    final ratio = reported > 0 ? reported : _defaultRatio;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final height = (available / ratio).clamp(1.0, maxHeight);
        final width = height * ratio;

        return Center(
          child: SizedBox(
            width: width > available ? available : width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: ColoredBox(
                color: Colors.black,
                child: ready
                    // The box already carries the clip's ratio, so a bare
                    // VideoPlayer fills it without distorting.
                    ? VideoPlayer(player)
                    : Image.asset(fallbackAsset, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }
}
