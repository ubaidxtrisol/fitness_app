import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String dayLabel;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.dayLabel = 'Day 1',
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: SvgPicture.asset('assets/svgs/arrow.svg'),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        physics: const BouncingScrollPhysics(),
        children: [
          // Top Banner Video Player Card
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8ED),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.dayLabel,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        6.heightBox,
                        Text(
                          exercise.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          20.heightBox,

          // Exercise Title Tag
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          16.heightBox,

          // Duration Row with - / + Steppers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  // Minus Button
                  GestureDetector(
                    onTap: () => _adjustDuration(-5),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFC7CDD8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        size: 16,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                  ),
                  12.widthBox,

                  // Duration text (e.g., 00:35)
                  Text(
                    _formatDuration(_durationSeconds),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  12.widthBox,

                  // Plus Button
                  GestureDetector(
                    onTap: () => _adjustDuration(5),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFC7CDD8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          24.heightBox,

          // How to Do Section
          if (exercise.howToDo.isNotEmpty) ...[
            const Text(
              'How to Do',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            10.heightBox,
            ...exercise.howToDo.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C434C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.heightBox,
          ],

          // Common Mistake Section
          if (exercise.commonMistakes.isNotEmpty) ...[
            const Text(
              'Common Mistake',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            10.heightBox,
            ...exercise.commonMistakes.map(
              (mistake) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        mistake,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C434C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.heightBox,
          ],

          // Breathing Tip Section
          if (exercise.breathingTips.isNotEmpty) ...[
            const Text(
              'Breathing Tip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            10.heightBox,
            ...exercise.breathingTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(
                        Icons.circle,
                        size: 5,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C434C),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
