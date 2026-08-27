import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/repositories/exercise_prefs_repository.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/views/exercise_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Exercise detail — Figma 11:959 (workout flow) and 16:356 (discover flow).
///
/// Both nodes are the same layout; only the workout flow shows the favourite
/// heart, so it is opt-in via [showFavorite]. The hero (16:374) is static
/// artwork, not a video preview — see [ExercisePlayerScreen] for playback.
class ExerciseDetailScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String dayLabel;
  final bool showFavorite;

  /// The run "Start Now" launches. Every flow passes the same session its own
  /// Start button uses, so the player logs against the right plan; the button
  /// jumps straight to [exerciseIndex].
  ///
  /// Null falls back to a one-exercise, untracked run.
  final PlayerSession? session;
  final int exerciseIndex;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.dayLabel = 'Day 1',
    this.showFavorite = false,
    this.session,
    this.exerciseIndex = 0,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final ExercisePrefsRepository _prefs = ExercisePrefsRepository();

  bool _isFavorite = false;

  /// What the user dialled in for this exercise, if anything. Null means the
  /// catalogue's own duration still wins.
  int? _override;

  /// The stepper's value: the saved override, else whatever the catalogue
  /// claims.
  int get _durationSeconds {
    final saved = _override;
    if (saved != null && saved > 0) return saved;

    return widget.exercise.durationSeconds > 0
        ? widget.exercise.durationSeconds
        : 35;
  }

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final saved = await _prefs.durationFor(widget.exercise.exerciseId);
    if (!mounted) return;
    setState(() => _override = saved);
  }

  /// Steps the duration and caches it against this exercise, so the player and
  /// the next visit to this screen both pick it up.
  void _adjustDuration(int delta) {
    final next = (_durationSeconds + delta).clamp(
      ExercisePrefsRepository.minSeconds,
      ExercisePrefsRepository.maxSeconds,
    );
    if (next == _durationSeconds) return;

    setState(() => _override = next);
    _prefs.setDuration(widget.exercise.exerciseId, next);
  }

  /// Opens the shared player on this exercise. The player re-reads the cached
  /// duration, so the clip loops for exactly what the stepper shows.
  Future<void> _startNow() async {
    final session = widget.session;
    await context.push(
      ExercisePlayerScreen(
        session: session == null
            ? PlayerSession(
                exercises: [widget.exercise],
                workoutTitle: widget.exercise.title,
              )
            : session.startingAt(widget.exerciseIndex),
      ),
    );
  }

  String _formatDuration(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
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
      // Start Now (matches the 52pt r20 Start button on 11:738 / 12:2422).
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _startNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(
                'Start Now · ${_formatDuration(_durationSeconds)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 30),
        physics: const BouncingScrollPhysics(),
        children: [
          // Banner (16:374) — static artwork, matching the challenge/program
          // hero banners rather than a live preview.
          _ExerciseBanner(
            dayLabel: widget.dayLabel,
            title: exercise.title,
            thumbnailUrl: exercise.thumbnailUrl,
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

/// Static hero artwork — Figma 16:374/375/376/377.
///
/// 361x169, r20, `#fbe3e5` — the same banner shell as [ChallengeHeroBanner]
/// (`assets/images/challenge_banner.png` is byte-identical to this node's
/// background fill). The exercise's own thumbnail bleeds off the right edge
/// in place of the bundled model shot, with the day/title copy overlaid on
/// the left. This is deliberately static — no video plays on this screen,
/// only inside [ExercisePlayerScreen].
class _ExerciseBanner extends StatelessWidget {
  final String dayLabel;
  final String title;
  final String thumbnailUrl;

  static const double _designWidth = 361;
  static const double _height = 169;

  const _ExerciseBanner({
    required this.dayLabel,
    required this.title,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The photo is placed by design coordinates, so scale them if the
        // banner is not exactly 361 wide.
        final scale = constraints.maxWidth / _designWidth;

        return Container(
          height: _height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFFBE3E5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 4),
            ],
          ),
          child: Stack(
            children: [
              // Decorative artwork (16:375) — 361x180 anchored one pixel
              // above the top; shared with the challenge/program banners.
              Positioned(
                left: 0,
                top: -1 * scale,
                width: constraints.maxWidth,
                height: 180 * scale,
                child: Image.asset(
                  'assets/images/challenge_banner.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Exercise photo (16:376) — 164x170 at (190, -1), bleeding off
              // the right edge.
              if (thumbnailUrl.isNotEmpty)
                Positioned(
                  left: 190 * scale,
                  top: -1 * scale,
                  width: 164 * scale,
                  height: 170 * scale,
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),

              // Day label + title (16:377).
              Positioned(
                left: 24 * scale,
                top: 58 * scale,
                child: SizedBox(
                  width: 160 * scale,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dayLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 29.308,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      6.513.heightBox,
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),
        );
      },
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
