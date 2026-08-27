import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Challenge card — Figma `Frame 19` (node 8:32), 113x142 on a 393pt frame.
class ChallengeCardWidget extends StatefulWidget {
  static const double width = 113;
  static const double height = 142;

  final ChallengeModel challenge;
  final VoidCallback? onJoin;

  const ChallengeCardWidget({super.key, required this.challenge, this.onJoin});

  @override
  State<ChallengeCardWidget> createState() => _ChallengeCardWidgetState();
}

class _ChallengeCardWidgetState extends State<ChallengeCardWidget> {
  static const double _imageHeight = 96.703;

  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.challenge.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;

    return Container(
      width: ChallengeCardWidget.width,
      height: ChallengeCardWidget.height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 1.256),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            // Cover image — fills the card width down to y=96.703.
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: _imageHeight,
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
              left: 6.279,
              top: 6.279,
              width: 100.832,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DaysBadge(label: challenge.daysLabel),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _isFav = !_isFav),
                    child: SvgPicture.asset(
                      'assets/svgs/favorit_fill.svg',
                      width: 11.111,
                      height: 10,
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
              left: 5.015,
              top: 103,
              right: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/users.svg',
                        width: 10.047,
                        height: 10.047,
                      ),
                      const SizedBox(width: 3.768),
                      Text(
                        challenge.userCount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 7.535,
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
              left: 72.015,
              top: 124,
              child: GestureDetector(
                onTap: widget.onJoin,
                child: Container(
                  height: 13,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEC),
                    borderRadius: BorderRadius.circular(7.535),
                  ),
                  child: const Text(
                    'Join',
                    style: TextStyle(
                      fontSize: 7.535,
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
    );
  }
}

class _DaysBadge extends StatelessWidget {
  final String label;

  const _DaysBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 11.303,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6.279),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFD),
        borderRadius: BorderRadius.circular(3.768),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 0.628),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 5.024,
          height: 1.393,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
