import 'package:fitness_app/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// The Discover screen's first-load skeleton — shaped like the real
/// category sections (title + a horizontal rail of [DiscoverWorkoutCard]s)
/// so the swap-in when data arrives doesn't jump around.
class DiscoverCategoryShimmer extends StatelessWidget {
  const DiscoverCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(children: List.generate(2, (_) => const _ShimmerSection())),
    );
  }
}

class _ShimmerSection extends StatelessWidget {
  const _ShimmerSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ShimmerBox(
              width: 150,
              height: 17,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 245,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 6),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              // Sized to match DiscoverWorkoutCard's default 224x216.
              itemBuilder: (context, index) => const ShimmerBox(
                width: 224,
                height: 216,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
