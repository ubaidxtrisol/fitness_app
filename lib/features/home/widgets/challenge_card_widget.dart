import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Challenge card — Figma `Frame 19`.
///
/// Node 8:32 draws it at 113x142 for the Home rail; node 11:1507 draws the
/// identical card at 172.256x216.463 for the Challenges grid, which is exactly
/// [gridScale] times larger. Every measurement below is the 113pt base times
/// [scale], so both nodes come from one component.
class ChallengeCardWidget extends StatefulWidget {
  static const double width = 113;
  static const double height = 142;

  /// 172.25608 / 113 — the Challenges grid (Figma 11:1397).
  static const double gridScale = 1.5244;

  final ChallengeModel challenge;
  final double scale;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const ChallengeCardWidget({
    super.key,
    required this.challenge,
    this.scale = 1,
    this.onJoin,
    this.onTap,
  });

  @override
  State<ChallengeCardWidget> createState() => _ChallengeCardWidgetState();
}

class _ChallengeCardWidgetState extends State<ChallengeCardWidget> {
  static const double _imageHeight = 96.703;

  late bool _isFav;

  /// Scales a base (113pt-card) measurement to the requested card size.
  double _s(double base) => base * widget.scale;

  @override
  void initState() {
    super.initState();
    _isFav = widget.challenge.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: _s(ChallengeCardWidget.width),
        height: _s(ChallengeCardWidget.height),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(_s(13)),
          boxShadow: [
            BoxShadow(color: const Color(0x14000000), blurRadius: _s(1.256)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_s(13)),
          child: Stack(
            children: [
              // Cover image — fills the card width down to y=96.703.
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: _s(_imageHeight),
                child: Image.network(
                  challenge.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF4F5F7),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Days badge + favourite heart (Frame 127).
              Positioned(
                left: _s(6.279),
                top: _s(6.279),
                width: _s(100.832),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _DaysBadge(label: challenge.daysLabel, scale: widget.scale),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _isFav = !_isFav),
                      child: SvgPicture.asset(
                        'assets/svgs/favorit_fill.svg',
                        width: _s(11.111),
                        height: _s(10),
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          _isFav ? AppColors.primary : Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title + user count (Frame 34).
              Positioned(
                left: _s(5.015),
                top: _s(103),
                right: _s(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _s(9),
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: _s(9)),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/users.svg',
                          width: _s(10.047),
                          height: _s(10.047),
                        ),
                        SizedBox(width: _s(3.768)),
                        Text(
                          challenge.userCount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _s(7.535),
                            height: 1.333,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Join pill (Frame 20).
              Positioned(
                left: _s(72.015),
                top: _s(124),
                child: GestureDetector(
                  onTap: widget.onJoin,
                  child: Container(
                    height: _s(13),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: _s(10)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEC),
                      borderRadius: BorderRadius.circular(_s(7.535)),
                    ),
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontSize: _s(7.535),
                        height: 1,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
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

class _DaysBadge extends StatelessWidget {
  final String label;
  final double scale;

  const _DaysBadge({required this.label, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 11.303 * scale,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 6.279 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(3.768 * scale),
        boxShadow: [
          BoxShadow(color: const Color(0x40000000), blurRadius: 0.628 * scale),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 5.024 * scale,
          height: 1.393,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
