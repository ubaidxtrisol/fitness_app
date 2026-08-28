import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer_pro/flutter_shimmer_pro.dart';

/// The app's one shimmer look — [AppColors.shimmerBase] /
/// [AppColors.shimmerHighlight], a gentle wave.
///
/// Per the package's own guidance, one [Shimmer] wrapping a whole skeleton
/// layout renders (and performs) better than wrapping each placeholder in
/// its own — so build the skeleton out of [ShimmerBox]es and wrap the
/// *group* in a single [AppShimmer], not one per box.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Duration period;

  const AppShimmer({
    super.key,
    required this.child,
    this.period = const Duration(milliseconds: 1400),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: period,
      child: child,
    );
  }
}

/// One opaque, rounded skeleton block. Its own color doesn't matter — an
/// ancestor [AppShimmer] repaints every opaque pixel with its gradient — so
/// this only needs to be the right shape.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: borderRadius),
    );
  }
}

/// Drop-in replacement for `Image.network`'s `loadingBuilder` — a shimmering
/// placeholder sized to fill whatever box the image sits in.
Widget shimmerImagePlaceholder({BorderRadius borderRadius = BorderRadius.zero}) {
  return AppShimmer(
    child: ShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius: borderRadius,
    ),
  );
}
