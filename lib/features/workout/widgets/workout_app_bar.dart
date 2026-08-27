import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Back chevron + optional favourite heart.
///
/// Figma 10:509 / 11:738 / 11:959 — back tile 30x30 r7 at x=16, heart 24x24
/// with its right edge at x=377 (16 from the frame edge).
class WorkoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showFavorite;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggled;

  /// Centred title — Figma 11:1564 ("Challenges") and 11:1843 ("Flat Belly").
  /// The workout detail screens have no title.
  final String? title;

  /// Figma 11:1843 / 11:1564 set the title in Nexa Bold; 14:642 uses
  /// NexaText Regular.
  final FontWeight titleWeight;

  const WorkoutAppBar({
    super.key,
    this.showFavorite = true,
    this.isFavorite = false,
    this.onFavoriteToggled,
    this.title,
    this.titleWeight = FontWeight.w700,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 40,
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: titleWeight,
                color: AppColors.textPrimary,
              ),
            ),
      leadingWidth: 16 + 30 + 8,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(color: Color(0x17000000), blurRadius: 3),
                ],
              ),
              padding: const EdgeInsets.all(5),
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
        if (showFavorite)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onFavoriteToggled,
                // Figma 13:2576: a 24x24 asset box holding a 20x18 glyph.
                // The project's heart svg is that glyph in a 21x19 viewBox.
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      isFavorite
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
    );
  }
}
