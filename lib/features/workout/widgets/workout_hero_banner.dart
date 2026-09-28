import 'package:flutter/material.dart';

/// The pink program artwork used behind both hero banners.
///
/// Figma 10:509 (node 10:729) and 11:738 (node 11:958) share one image fill,
/// 361x172 with a 16 radius; only the overlaid copy differs.
class WorkoutHeroBanner extends StatelessWidget {
  static const String defaultAsset = 'assets/images/program_banner.png';

  final double height;
  final EdgeInsets contentPadding;
  final Widget child;
  final String? thumbnailUrl;
  final String? imageUrl;
  final String? assetPath;

  const WorkoutHeroBanner({
    super.key,
    this.height = 202,
    required this.contentPadding,
    this.thumbnailUrl,
    this.imageUrl,
    this.assetPath,
    required this.child,
  });

  bool get _hasCustomThumbnail {
    final rawUrl = (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty)
        ? thumbnailUrl!.trim()
        : (imageUrl != null && imageUrl!.trim().isNotEmpty)
        ? imageUrl!.trim()
        : (assetPath != null && assetPath!.trim().isNotEmpty)
        ? assetPath!.trim()
        : null;
    return rawUrl != null && rawUrl != defaultAsset;
  }

  Widget _buildImage() {
    final rawUrl = (thumbnailUrl != null && thumbnailUrl!.trim().isNotEmpty)
        ? thumbnailUrl!.trim()
        : (imageUrl != null && imageUrl!.trim().isNotEmpty)
        ? imageUrl!.trim()
        : (assetPath != null && assetPath!.trim().isNotEmpty)
        ? assetPath!.trim()
        : null;

    if (rawUrl == null) {
      return Image.asset(defaultAsset, fit: BoxFit.cover);
    }

    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return Image.network(
        rawUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(defaultAsset, fit: BoxFit.cover),
      );
    }

    return Image.asset(
      rawUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset(defaultAsset, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF7EBE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(),
          if (_hasCustomThumbnail)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.90),
                    Colors.white.withValues(alpha: 0.50),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 0.95],
                ),
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
  }
}
