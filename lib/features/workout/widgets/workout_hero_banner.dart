import 'package:flutter/material.dart';

/// The pink program artwork used behind both hero banners.
///
/// Figma 10:509 (node 10:729) and 11:738 (node 11:958) share one image fill,
/// 361x172 with a 16 radius; only the overlaid copy differs.
class WorkoutHeroBanner extends StatelessWidget {
  static const String assetPath = 'assets/images/program_banner.png';

  final double height;
  final EdgeInsets contentPadding;
  final Widget child;

  const WorkoutHeroBanner({
    super.key,
    this.height = 172,
    required this.contentPadding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(assetPath, fit: BoxFit.cover),
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
  }
}
