import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shared chrome for the player screens: the pink artwork behind everything and
/// the 30x30 back tile at (16, 61). Figma 11:1202 / 11:1236 / 11:1313.
class PlayerScaffold extends StatelessWidget {
  /// The player screens reuse the program artwork as their backdrop — the three
  /// Figma nodes export the identical image fill.
  static const String backgroundAsset = 'assets/images/program_banner.png';

  final Widget? backdrop;
  final Widget child;
  final VoidCallback? onBack;

  const PlayerScaffold({
    super.key,
    this.backdrop,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(backgroundAsset, fit: BoxFit.cover),
          ?backdrop,
          child,

          // Back tile (11:1215) — r8 here, unlike the r7 used on detail screens.
          Positioned(
            left: 16,
            top: MediaQuery.of(context).padding.top + 2,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
        ],
      ),
    );
  }
}

/// The 361x210 white sheet (r26) both the ready and player screens sit on.
class PlayerSheet extends StatelessWidget {
  final Widget child;

  const PlayerSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
      ),
      child: child,
    );
  }
}
