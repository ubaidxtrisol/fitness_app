import 'dart:async';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/active_session_repository.dart';
import 'package:fitness_app/core/database/repositories/exercise_prefs_repository.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/core/database/repositories/settings_repository.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/workout_complete_screen.dart';
import 'package:fitness_app/features/player/widgets/exercise_celebration.dart';
import 'package:fitness_app/features/player/widgets/get_ready_card.dart';
import 'package:fitness_app/features/player/widgets/paused_overlay.dart';
import 'package:fitness_app/features/player/widgets/player_scaffold.dart';
import 'package:fitness_app/features/player/widgets/resume_session_dialog.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti_plus/flutter_confetti_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

/// Exercise player — Figma 11:1235.
///
/// One screen for the whole run: get-ready countdown, playing, the in-place
/// pause state and the between-exercise celebration all live here and cross
/// fade via [AnimatedSwitcher] instead of pushing separate routes, so a back
/// tap mid-exercise never leaves this screen — it just animates the pause
/// state in over the same background.
///
/// Honours the user's workout settings (countdown, volume, sound effects) and
/// logs every finished exercise and the session as a whole. Shared by every
/// flow that can start a workout.
class ExercisePlayerScreen extends StatefulWidget {
  final PlayerSession session;

  const ExercisePlayerScreen({super.key, required this.session});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

/// What's currently cross-faded into view.
enum _Phase {
  /// Countdown before an exercise starts — the first one and every one after.
  getReady,

  /// The clip is running and the transport is live.
  playing,

  /// Shown in place of the transport — no navigation, so resuming lands right
  /// back where the user left off.
  paused,

  /// The confetti + "Exercise Complete!" beat between two exercises, before
  /// the next one's get-ready countdown begins.
  celebrating,
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen>
    with WidgetsBindingObserver {
  final ProgressRepository _progress = ProgressRepository();
  final SettingsRepository _settingsRepo = SettingsRepository();
  final ExercisePrefsRepository _prefs = ExercisePrefsRepository();
  final ActiveSessionRepository _activeSessions = ActiveSessionRepository();

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

  /// True once settings/video/resume-offer have all resolved and the first
  /// get-ready countdown is running. Blank screen (just the backdrop) before
  /// that — nothing is interactive yet.
  bool _booted = false;

  _Phase _phase = _Phase.getReady;

  /// What to return to when "Keep exercising" is tapped.
  _Phase? _phaseBeforePause;

  /// Set while celebrating; the get-ready countdown that follows targets this.
  int? _pendingNextIndex;

  /// Countdown left on the get-ready screen.
  int _readyRemaining = 0;

  /// Per-second ticker while [_Phase.playing].
  Timer? _ticker;

  /// Drives the get-ready countdown and the celebration's auto-advance.
  Timer? _phaseTimer;

  bool _finishing = false;

  static const _celebrationDuration = Duration(milliseconds: 1800);

  DateTime _startedAt = DateTime.now();
  final Set<String> _loggedExerciseIds = {};
  int _completedCount = 0;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _index = widget.session.startIndex;
    _remaining = _durationFor(_index);
    _boot();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settingsSub?.cancel();
    _ticker?.cancel();
    _phaseTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  /// Pause playback and the clock when the app leaves the foreground so the
  /// timer cannot run down in the user's pocket.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed &&
        _booted &&
        _phase != _Phase.paused) {
      _pause();
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

    await _offerResume();
    if (!mounted) return;

    await _loadVideo(_index);
    if (!mounted) return;

    setState(() {
      _remaining = _durationFor(_index);
      _readyRemaining = _settings?.countdownSeconds ?? 5;
      _phase = _Phase.getReady;
      _booted = true;
    });
    _startReadyCountdown();
  }

  /// If this exact day was left mid-run, offers to pick up where it left off.
  ///
  /// Only for the plain Start button (`startIndex == 0`) — "Start Now" on a
  /// specific exercise is an explicit jump and skips this entirely.
  Future<void> _offerResume() async {
    if (!widget.session.isTrackable ||
        widget.session.startIndex != 0 ||
        widget.session.isEmpty) {
      return;
    }

    final saved = await _activeSessions.find(
      widget.session.planId,
      widget.session.dayId,
    );
    if (saved == null || !mounted) return;

    final completedIds = _activeSessions.decodeCompletedIds(
      saved.completedExerciseIdsJson,
    );
    if (completedIds.isEmpty) return;

    final choice = await showResumeSessionDialog(
      context,
      completedCount: completedIds.length,
      totalCount: widget.session.length,
    );
    if (!mounted) return;

    if (choice == ResumeChoice.resume) {
      setState(() {
        _loggedExerciseIds
          ..clear()
          ..addAll(completedIds);
        _completedCount = completedIds.length;
        _index = completedIds.length.clamp(0, widget.session.length - 1);
        _elapsedSeconds = saved.elapsedSeconds;
        _startedAt = saved.startedAt;
      });
    } else {
      await _activeSessions.clear(widget.session.planId, widget.session.dayId);
    }
  }

  /// Checkpoints progress so far, so the day can be resumed if the app closes
  /// before it's finished.
  Future<void> _saveCheckpoint() async {
    if (!widget.session.isTrackable) return;

    await _activeSessions.save(
      planId: widget.session.planId,
      dayId: widget.session.dayId,
      planType: widget.session.planType,
      planTitle: widget.session.planTitle.isEmpty
          ? widget.session.workoutTitle
          : widget.session.planTitle,
      dayTitle: widget.session.dayTitle,
      dayLevel: widget.session.dayLevel,
      dayIndex: widget.session.dayIndex,
      totalDays: widget.session.totalDays,
      completedExerciseIds: _loggedExerciseIds.toList(),
      elapsedSeconds: _elapsedSeconds,
      startedAt: _startedAt,
    );
  }

  Future<void> _clearCheckpoint() async {
    if (!widget.session.isTrackable) return;
    await _activeSessions.clear(widget.session.planId, widget.session.dayId);
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
      if (_phase == _Phase.playing) await controller.play();
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

  // ------------------------------------------------------------- get ready

  void _startReadyCountdown() {
    _phaseTimer?.cancel();
    if (_readyRemaining <= 0) {
      _phaseTimer = null;
      _beginPlaying();
      return;
    }
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_readyRemaining <= 1) {
        _phaseTimer?.cancel();
        _phaseTimer = null;
        _beginPlaying();
      } else {
        setState(() => _readyRemaining--);
      }
    });
  }

  void _skipReadyCountdown() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
    _beginPlaying();
  }

  void _beginPlaying() {
    if (!mounted) return;
    setState(() => _phase = _Phase.playing);
    _startPlayTicker();
  }

  // ----------------------------------------------------------------- timing

  void _startPlayTicker() {
    _ticker?.cancel();
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

  /// Logs the exercise that just ran out, marks it complete, then celebrates
  /// before the next one's get-ready countdown begins.
  Future<void> _completeCurrentExercise() async {
    // Guard against the periodic ticker firing again while this (now
    // `await`-heavy) handler is still running — it would otherwise skip a
    // second exercise before this one finishes processing.
    _ticker?.cancel();
    _ticker = null;

    final exercise = widget.session.exerciseAt(_index);
    final isLast = _index + 1 >= widget.session.length;

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

    if (isLast) {
      await _finish(PlayerOutcome.completed);
      return;
    }

    // Checkpoint before celebrating — if the app is killed the instant this
    // celebration is on screen, the finished exercise still isn't lost.
    await _saveCheckpoint();
    if (!mounted) return;

    _pendingNextIndex = _index + 1;
    _startCelebration();
  }

  void _startCelebration() {
    setState(() => _phase = _Phase.celebrating);
    _ringChime();
    // Fires after this frame so the overlay has a mounted `Overlay` to attach
    // its confetti to.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ConfettiPlus.success(context);
    });
    _scheduleCelebrationAdvance();
  }

  void _scheduleCelebrationAdvance() {
    _phaseTimer?.cancel();
    _phaseTimer = Timer(_celebrationDuration, _advanceAfterCelebration);
  }

  /// A short system chime — there's no bundled sound-effect asset or audio
  /// package in this project yet, so this is the one built-in "ring" Flutter
  /// offers without adding a dependency. Respects the same mute toggle the
  /// clip's own volume already honours.
  void _ringChime() {
    if (_settings?.soundEffectEnabled ?? true) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> _advanceAfterCelebration() async {
    _phaseTimer = null;
    final target = _pendingNextIndex;
    if (target == null || !mounted) return;
    _pendingNextIndex = null;

    await _loadVideo(target);
    if (!mounted) return;

    setState(() {
      _index = target;
      _remaining = _durationFor(target);
      _readyRemaining = _settings?.countdownSeconds ?? 5;
      _phase = _Phase.getReady;
    });
    _startReadyCountdown();
  }

  /// Manual skip — the transport's back arrow. Jumps straight there with no
  /// countdown, unlike a natural finish.
  Future<void> _goTo(int target) async {
    if (target < 0 || target >= widget.session.length) return;

    // Hold the clock while the next clip loads, otherwise the outgoing ticker
    // keeps draining the new exercise's time during the await.
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
    if (_phase == _Phase.playing) _startPlayTicker();
  }

  Future<void> _finish(PlayerOutcome outcome) async {
    if (_finishing) return;
    _finishing = true;
    _ticker?.cancel();
    _ticker = null;
    _phaseTimer?.cancel();
    _phaseTimer = null;
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
      // Whether the day was finished or deferred, this attempt is over —
      // there's nothing left to resume.
      await _clearCheckpoint();
    }

    if (!mounted) return;

    if (outcome == PlayerOutcome.completed) {
      await context.push(
        WorkoutCompleteScreen(
          planTitle: widget.session.planTitle.isEmpty
              ? widget.session.workoutTitle
              : widget.session.planTitle,
          dayTitle: widget.session.dayTitle.isEmpty
              ? widget.session.workoutTitle
              : widget.session.dayTitle,
          exercisesCompleted: _completedCount,
          exercisesTotal: widget.session.length,
          durationSeconds: _elapsedSeconds,
          calories: ProgressRepository.estimateCalories(_elapsedSeconds),
        ),
      );
      if (!mounted) return;
    }

    Navigator.of(context).pop(outcome);
  }

  // ----------------------------------------------------------------- pause

  /// Stops whichever ticker is currently running and cross-fades to the
  /// paused state in place — no navigation, so a back tap mid-exercise (or
  /// mid-countdown, or mid-celebration) never leaves this screen.
  void _pause() {
    if (_finishing || _phase == _Phase.paused) return;
    _phaseBeforePause = _phase;
    _ticker?.cancel();
    _ticker = null;
    _phaseTimer?.cancel();
    _phaseTimer = null;
    _controller?.pause();
    setState(() => _phase = _Phase.paused);
  }

  /// "Keep exercising" — cross-fades back to whatever was showing when the
  /// user paused, resuming its ticker rather than restarting it.
  void _resume() {
    final target = _phaseBeforePause ?? _Phase.playing;
    _phaseBeforePause = null;
    setState(() => _phase = target);

    switch (target) {
      case _Phase.playing:
        _controller?.play();
        _startPlayTicker();
      case _Phase.getReady:
        _startReadyCountdown();
      case _Phase.celebrating:
        _scheduleCelebrationAdvance();
      case _Phase.paused:
        break;
    }
  }

  Future<void> _restart() async {
    _ticker?.cancel();
    _ticker = null;
    _phaseTimer?.cancel();
    _phaseTimer = null;
    _phaseBeforePause = null;
    _pendingNextIndex = null;
    _completedCount = 0;
    _loggedExerciseIds.clear();
    _elapsedSeconds = 0;
    _startedAt = DateTime.now();
    await _clearCheckpoint();
    if (!mounted) return;

    await _loadVideo(0);
    if (!mounted) return;

    setState(() {
      _index = 0;
      _remaining = _durationFor(0);
      _readyRemaining = _settings?.countdownSeconds ?? 5;
      _phase = _Phase.getReady;
    });
    _startReadyCountdown();
  }

  Future<void> _doItLater() => _finish(PlayerOutcome.later);

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    if (widget.session.isEmpty) {
      return const PlayerScaffold(child: SizedBox.shrink());
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (!_booted) {
          Navigator.of(context).pop();
          return;
        }
        // Back while already paused just resumes — same as dismissing the
        // paused screen used to behave when it was its own route.
        if (_phase == _Phase.paused) {
          _resume();
        } else {
          _pause();
        }
      },
      child: PlayerScaffold(
        onBack: !_booted
            ? () => Navigator.of(context).pop()
            : (_phase == _Phase.paused ? _resume : _pause),
        // The paused state (Figma 11:1312) has no back arrow of its own.
        showBack: _phase != _Phase.paused,
        child: !_booted
            ? const SizedBox.shrink()
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.96,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_phase),
                  child: switch (_phase) {
                    _Phase.getReady => _buildGetReady(),
                    _Phase.playing => _buildPlaying(),
                    _Phase.celebrating => _buildCelebrating(),
                    _Phase.paused => _buildPaused(),
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildGetReady() {
    final exercise = widget.session.exerciseAt(_index);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Same banner the player uses, so the hand-off is seamless.
            VideoBanner(
              controller: _controller,
              isReady: _videoReady,
              maxHeight: MediaQuery.sizeOf(context).height * 0.36,
            ),
            const Spacer(),
            PlayerSheet(
              child: GetReadyCard(
                remaining: _readyRemaining,
                exerciseTitle: exercise.title,
                onSkip: _skipReadyCountdown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrating() {
    final justFinished = widget.session.exerciseAt(_index);
    final nextIndex = _pendingNextIndex;
    return SafeArea(
      child: ExerciseCelebration(
        title: justFinished.title,
        nextTitle: nextIndex != null
            ? widget.session.exerciseAt(nextIndex).title
            : null,
      ),
    );
  }

  Widget _buildPaused() {
    return PausedOverlay(
      onKeepExercising: _resume,
      onRestart: _restart,
      onLater: _doItLater,
    );
  }

  Widget _buildPlaying() {
    final exercise = widget.session.exerciseAt(_index);
    final total = _durationFor(_index);
    final progress = total == 0 ? 0.0 : (total - _remaining) / total;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
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
                          onTap: _pause,
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
