import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/bloc/discover_bloc.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/views/category_detail_screen.dart';
import 'package:fitness_app/features/discover/views/workout_detail_screen.dart';
import 'package:fitness_app/features/discover/widgets/discover_category_shimmer.dart';
import 'package:fitness_app/features/discover/widgets/discover_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Discover tab — the Pilates catalogue from the API (`GET
/// /api/v1/pilates/categories`), falling back to the last cached copy or the
/// bundled JSON when the network isn't available. See [DiscoverBloc] /
/// [DiscoverRepository] for the load/fallback logic; this widget only reacts
/// to state, no `setState` anywhere in the load path.
class DiscoverScreen extends StatelessWidget {
  final void Function(CategoryModel category)? onCategorySelected;
  final void Function(WorkoutModel workout)? onWorkoutSelected;

  const DiscoverScreen({
    super.key,
    this.onCategorySelected,
    this.onWorkoutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverBloc()..add(const DiscoverCategoriesRequested()),
      child: _DiscoverView(
        onCategorySelected: onCategorySelected,
        onWorkoutSelected: onWorkoutSelected,
      ),
    );
  }
}

class _DiscoverView extends StatelessWidget {
  final void Function(CategoryModel category)? onCategorySelected;
  final void Function(WorkoutModel workout)? onWorkoutSelected;

  const _DiscoverView({this.onCategorySelected, this.onWorkoutSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final bloc = context.read<DiscoverBloc>();
            bloc.add(const DiscoverCategoriesRefreshed());
            await bloc.stream.firstWhere(
              (state) => state.status != DiscoverStatus.refreshing,
            );
          },
          child: BlocBuilder<DiscoverBloc, DiscoverState>(
            builder: (context, state) => _buildBody(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DiscoverState state) {
    final showSkeleton =
        state.categories.isEmpty &&
        (state.status == DiscoverStatus.initial || state.status == DiscoverStatus.loading);
    final showError = state.categories.isEmpty && state.status == DiscoverStatus.failure;
    final showEmpty =
        state.categories.isEmpty && state.status == DiscoverStatus.success;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        // Header Sliver
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning Emily',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "Let's continue your wellness journey",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C434C),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/svgs/notifications.svg', height: 22),
                ),
              ],
            ),
          ),
        ),

        if (state.notice != null)
          SliverToBoxAdapter(child: _NoticeBanner(message: state.notice!)),

        if (showSkeleton)
          const SliverToBoxAdapter(child: DiscoverCategoryShimmer())
        else if (showError)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _DiscoverErrorView(
              message: state.errorMessage ?? 'Something went wrong.',
              onRetry: () =>
                  context.read<DiscoverBloc>().add(const DiscoverCategoriesRequested()),
            ),
          )
        else if (showEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No categories found.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final category = state.categories[index];
              return _buildCategorySection(context, category);
            }, childCount: state.categories.length),
          ),

        // Bottom Spacing for Floating Navbar
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context, CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: Title & "See All"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (onCategorySelected != null) {
                      onCategorySelected!(category);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(category: category),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C434C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.heightBox,

          // Horizontal List of Workouts
          SizedBox(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 6),
              itemCount: category.workouts.length,
              itemBuilder: (context, index) {
                final workout = category.workouts[index];
                return DiscoverWorkoutCard(
                  workout: workout,
                  onTap: () {
                    if (onWorkoutSelected != null) {
                      onWorkoutSelected!(workout);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorkoutDetailScreen(workout: workout),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Non-blocking context for why the catalogue isn't live network data —
/// [DiscoverState.notice].
class _NoticeBanner extends StatelessWidget {
  final String message;

  const _NoticeBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.primary),
            8.widthBox,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 11, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DiscoverErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
            12.heightBox,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            16.heightBox,
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
