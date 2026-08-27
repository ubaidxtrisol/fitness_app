import 'package:flutter/material.dart';

/// Challenge hero — Figma 12:1854 (detail) and 12:2480 (day).
///
/// 361x169, r20, `#fbe3e5`, with the pink artwork behind and the model bleeding
/// off the top-right. Only the overlaid copy differs between the two nodes.
class ChallengeHeroBanner extends StatelessWidget {
  static const double _designWidth = 361;
  static const double height = 169;

  final EdgeInsets contentPadding;
  final Widget child;

  const ChallengeHeroBanner({
    super.key,
    required this.contentPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The model is placed by design coordinates, so scale them if the
        // banner is not exactly 361 wide.
        final scale = constraints.maxWidth / _designWidth;

        return Container(
          height: height,
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
              // Artwork (12:1874) — 361x180 anchored one pixel above the top.
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

              // Model (12:1853) — 164x299 at (181, -61), bleeding off the top.
              Positioned(
                left: 181 * scale,
                top: -61 * scale,
                width: 164 * scale,
                height: 299 * scale,
                child: Image.asset(
                  'assets/images/challenge_model.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              Padding(
                padding: contentPadding,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [child],
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
