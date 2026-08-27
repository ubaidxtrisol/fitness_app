import 'dart:async';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/exercise_prefs_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/core/database/repositories/settings_repository.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/get_ready_screen.dart';
import 'package:fitness_app/features/player/views/workout_paused_screen.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

/// Exercise player — Figma 11:1235.
///
/// Plays the real clip full-bleed behind the sheet, honours the user's workout
/// settings (countdown, volume, sound effects) and logs every finished exercise
/// and the session as a whole. Shared by every flow that can start a workout.
class ExercisePlayerScreen extends StatefulWidget {
  final PlayerSession session;

  const ExercisePlayerScreen({super.key, required this.session});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen>
    with WidgetsBindingObserver {
  final ProgressRepository _progress = ProgressRepository();
  final SettingsRepository _settingsRepo = SettingsRepository();
  final ExercisePrefsRepository _prefs = ExercisePrefsRepository();

  VideoPlayerController? _controller;
  bool _videoReady = false;

  WorkoutSettingsRow? _settings;
  StreamSubscription<WorkoutSettingsRow>? _settingsSub;

  /// Durations the user dialled in on the detail screen, by exercise id.
  Map<String, int> _durationOverrides = const {};

  /// Natural clip length per exercise index, filled in as clips initialise.
  final Map<int, int> _clipSeconds = {};

  late int _index;
  late int _remaining;
  Timer? _ticker;
  bool _running = false;
  bool _finishing = false;

  late final DateTime _startedAt;
  final Set<String> _loggedExerciseIds = {};
  int _completedCount = 0;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startedAt = DateTime.now();
    _index = widget.session.startIndex;
    _remaining = _durationFor(_index);
    _boot();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settingsSub?.cancel();
    _ticker?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// Pause playback and the clock when the app leaves the foreground so the
  /// timer cannot run down in the user's pocket.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _running) {
      _stop();
      _controller?.pause();
    }
  }

  Future<void> _boot() async {
    _settings = await _settingsRepo.load();
    _durationOverrides = await _prefs.durationsFor(
      widget.session.exercises.map((e) => e.exerciseId),
    );
    if (!mounted) return;
    setState(() => _remaining = _durationFor(_index));

    // Volume, mute and the countdown are global settings — a change made while
    // a workout is open takes effect on the spot.
    _settingsSub = _settingsRepo.watch().listen((row) {
      if (!mounted) return;
      setState(() => _settings = row);
      _controller?.setVolume(_playbackVolume);
    });

    await _loadVideo(_index);
    if (!mounted) return;
    setState(() => _remaining = _durationFor(_index));
    await _showGetReady();
  }

  /// How long this exercise runs for: the duration cached from the detail
  /// screen's stepper, else the clip's own length, else the catalogue value.
  /// The clip loops until the time is up, then the player skips on.
  int _durationFor(int index) {
    if (widget.session.isEmpty) return 0;

    final exercise = widget.session.exerciseAt(index);

    final override = _durationOverrides[exercise.exerciseId];
    if (override != null && override > 0) return override;

    final clip = _clipSeconds[index];
    if (clip != null && clip > 0) return clip;

    return exercise.durationSeconds > 0 ? exercise.durationSeconds : 35;
  }

  String _format(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // ------------------------------------------------------------------ video

  Future<void> _loadVideo(int index) async {
    if (widget.session.isEmpty) return;

    final url = widget.session.exerciseAt(index).videoUrl;
    final previous = _controller;
    _controller = null;
    if (mounted) setState(() => _videoReady = false);
    await previous?.dispose();

    if (url.isEmpty) return;

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      await controller.setLooping(true);
      // Voice guidance owns the audio channel; when it is off the clip carries
      // the sound at the configured volume.
      await controller.setVolume(_playbackVolume);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      final natural = controller.value.duration.inSeconds;
      setState(() {
        _controller = controller;
        _videoReady = true;
        if (natural > 0) _clipSeconds[index] = natural;
      });
      if (_running) await controller.play();
    } catch (_) {
      // The backdrop falls back to the bundled artwork.
      if (mounted) setState(() => _videoReady = false);
    }
  }

  double get _playbackVolume {
    final settings = _settings;
    if (settings == null) return 0.6;
    return settings.soundEffectEnabled ? settings.volume : 0.0;
  }

  // ----------------------------------------------------------------- timing

  Future<void> _showGetReady() async {
    if (widget.session.isEmpty) return;

    await context.push(
      GetReadyScreen(
        exercise: widget.session.exerciseAt(_index),
        countdownSeconds: _settings?.countdownSeconds ?? 5,
        controller: _controller,
        isVideoReady: _videoReady,
        onSkip: () => Navigator.of(context).pop(),
      ),
    );
    if (mounted) _start();
  }

  void _start() {
    _ticker?.cancel();
    setState(() => _running = true);
    _controller?.play();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _elapsedSeconds++;
      if (_remaining <= 1) {
        _completeCurrentExercise();
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

  /// Logs the exercise that just ran out, then moves on.
  Future<void> _completeCurrentExercise() async {
    final exercise = widget.session.exerciseAt(_index);

    if (_loggedExerciseIds.add('${exercise.exerciseId}#$_index')) {
      _completedCount++;
      await _progress.recordExercise(
        exerciseId: exercise.exerciseId.isEmpty
            ? 'ex_$_index'
            : exercise.exerciseId,
        title: exercise.title,
        durationSeconds: _durationFor(_index),
        thumbnailUrl: exercise.thumbnailUrl,
      );
    }

    if (_index + 1 >= widget.session.length) {
      await _finish(PlayerOutcome.completed);
      return;
    }
    await _goTo(_index + 1);
  }

  Future<void> _goTo(int target) async {
    if (target < 0 || target >= widget.session.length) return;

    // Hold the clock while the next clip loads, otherwise the outgoing ticker
    // keeps draining the new exercise's time during the await.
    final wasRunning = _running;
    _ticker?.cancel();
    _ticker = null;

    setState(() {
      _index = target;
      _remaining = _durationFor(target);
    });
    await _loadVideo(target);
    if (!mounted) return;

    // The clip's length is only known once it has initialised.
    setState(() => _remaining = _durationFor(target));
    if (wasRunning) _start();
  }

  Future<void> _finish(PlayerOutcome outcome) async {
    if (_finishing) return;
    _finishing = true;
    _stop();
    await _controller?.pause();

    if (widget.session.isTrackable) {
      await _progress.recordSession(
        planId: widget.session.planId,
        planType: widget.session.planType,
        planTitle: widget.session.planTitle.isEmpty
            ? widget.session.workoutTitle
            : widget.session.planTitle,
        dayId: widget.session.dayId,
        dayTitle: widget.session.dayTitle,
        dayLevel: widget.session.dayLevel,
        dayIndex: widget.session.dayIndex,
        totalDays: widget.session.totalDays,
        exercisesCompleted: _completedCount,
        exercisesTotal: widget.session.length,
        durationSeconds: _elapsedSeconds,
        startedAt: _startedAt,
        thumbnailUrl: widget.session.thumbnailUrl,
      );
    }

    if (mounted) Navigator.of(context).pop(outcome);
  }

  /// The design ships no pause glyph — the transport opens the paused screen
  /// (11:1312), which is the designed pause state.
  Future<void> _openPaused() async {
    _stop();
    await _controller?.pause();
    if (!mounted) return;

    final outcome = await context.push<PlayerOutcome>(
      const WorkoutPausedScreen(),
    );
    if (!mounted) return;

    switch (outcome) {
      case PlayerOutcome.restart:
        _completedCount = 0;
        _loggedExerciseIds.clear();
        _elapsedSeconds = 0;
        await _goTo(0);
        _start();
      case PlayerOutcome.later:
        await _finish(PlayerOutcome.later);
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _openPaused();
      },
      child: PlayerScaffold(
        onBack: _openPaused,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Spacer(),
              // The clip plays in a banner at its own aspect ratio — filling
              // the whole background cropped a 16:9 exercise to a strip.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: VideoBanner(
                  controller: _controller,
                  isReady: _videoReady,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.36,
                ),
              ),
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
                              onTap: () => _goTo(_index - 1),
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
                              onTap: _completeCurrentExercise,
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
