import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

/// Exercise detail — Figma 11:959 (workout flow) and 16:356 (discover flow).
///
/// Both nodes are the same layout; only the workout flow shows the favourite
/// heart, so it is opt-in via [showFavorite].
class ExerciseDetailScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String dayLabel;
  final bool showFavorite;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.dayLabel = 'Day 1',
    this.showFavorite = false,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _isFavorite = false;
  late int _durationSeconds;

  @override
  void initState() {
    super.initState();
    _durationSeconds = widget.exercise.durationSeconds > 0
        ? widget.exercise.durationSeconds
        : 35;
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.exercise.videoUrl.isEmpty) return;

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.exercise.videoUrl),
      );

      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _adjustDuration(int delta) {
    setState(() {
      final newDuration = _durationSeconds + delta;
      if (newDuration >= 5) {
        _durationSeconds = newDuration;
      }
    });
  }

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _forwardVideo(int seconds) {
    if (_videoController != null && _isVideoInitialized) {
      final currentPos = _videoController!.value.position;
      final targetPos = currentPos + Duration(seconds: seconds);
      _videoController!.seekTo(targetPos);
    }
  }

  void _rewindVideo(int seconds) {
    if (_videoController != null && _isVideoInitialized) {
      final currentPos = _videoController!.value.position;
      final targetPos = currentPos - Duration(seconds: seconds);
      _videoController!.seekTo(
        targetPos < Duration.zero ? Duration.zero : targetPos,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 40,
        leadingWidth: 16 + 30 + 8,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(color: Color(0x17000000), blurRadius: 3),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/svgs/arrow.svg',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        actions: [
          if (widget.showFavorite)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  // Figma 13:2584: 24x24 asset box, 20x18 glyph inside.
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: SvgPicture.asset(
                        _isFavorite
                            ? 'assets/svgs/favorit_fill.svg'
                            : 'assets/svgs/favorite.svg',
                        width: 21,
                        height: 19,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 30),
        physics: const BouncingScrollPhysics(),
        children: [
          // Banner (11:976) — the exercise animation plays here.
          Container(
            height: 232,
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8ED),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Video or Fallback Thumbnail
                if (_videoController != null &&
                    _isVideoInitialized &&
                    !_hasError)
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  )
                else if (exercise.thumbnailUrl.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      exercise.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFFDE8ED),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: AppColors.primary,
                          size: 48,
                        ),
                      ),
                    ),
                  )
                else
                  Container(color: const Color(0xFFFDE8ED)),

                // Video Interactive Controls Overlay
                if (_videoController != null && _isVideoInitialized)
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rewind 5s
                        GestureDetector(
                          onTap: () => _rewindVideo(5),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.replay_5_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        // Play / Pause Toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_videoController!.value.isPlaying) {
                                _videoController!.pause();
                              } else {
                                _videoController!.play();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        // Forward 5s
                        GestureDetector(
                          onTap: () => _forwardVideo(5),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.forward_5_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Left Title Overlay when not playing or on error
                if (!_isVideoInitialized)
                  Padding(
                    padding: const EdgeInsets.only(left: 22, top: 81),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.dayLabel,
                          style: const TextStyle(
                            fontSize: 29.308,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        6.513.heightBox,
                        Text(
                          exercise.title,
                          style: const TextStyle(
                            fontSize: 17.91,
                            height: 1.1,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          22.heightBox,

          // Everything below the banner sits at x=21 in the design (11:1134).
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise title (11:1072)
                Text(
                  exercise.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                16.heightBox,

                // Duration row with -/+ steppers (11:1104)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        _StepperButton(
                          asset: 'assets/svgs/stepper_minus.svg',
                          onTap: () => _adjustDuration(-5),
                        ),
                        9.widthBox,
                        Text(
                          _formatDuration(_durationSeconds),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        9.widthBox,
                        _StepperButton(
                          asset: 'assets/svgs/stepper_plus.svg',
                          onTap: () => _adjustDuration(5),
                        ),
                      ],
                    ),
                  ],
                ),
                24.heightBox,

                // Guidance sections (11:1128), 17 apart
                _GuidanceSection(title: 'How to Do', items: exercise.howToDo),
                _GuidanceSection(
                  title: 'Common Mistake',
                  items: exercise.commonMistakes,
                ),
                _GuidanceSection(
                  title: 'Breathing Tip',
                  items: exercise.breathingTips,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 23x22 outlined stepper — Figma 11:1080 (minus) and 11:1091 (plus).
class _StepperButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const _StepperButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SvgPicture.asset(asset, width: 23, height: 22),
    );
  }
}

/// Heading plus bulleted copy — Figma 11:1123 / 11:1124 / 11:1129.
class _GuidanceSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isLast;

  const _GuidanceSection({
    required this.title,
    required this.items,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          11.heightBox,
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 16.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5, right: 6),
                    child: Icon(
                      Icons.circle,
                      size: 3,
                      color: AppColors.textLight,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textLight,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
