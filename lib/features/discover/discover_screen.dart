import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/services/discover_repository.dart';
import 'package:fitness_app/features/discover/views/category_detail_screen.dart';
import 'package:fitness_app/features/discover/views/workout_detail_screen.dart';
import 'package:fitness_app/features/discover/widgets/discover_workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscoverScreen extends StatefulWidget {
  final Function(CategoryModel category)? onCategorySelected;
  final Function(WorkoutModel workout)? onWorkoutSelected;

  const DiscoverScreen({
    super.key,
    this.onCategorySelected,
    this.onWorkoutSelected,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = DiscoverRepository.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            setState(() {
              _categoriesFuture = DiscoverRepository.loadCategories();
            });
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Header Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Row(
                    children: [
                      // Leading Menu Icon Card
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 6,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(5.8),
                        child: SvgPicture.asset(
                          'assets/svgs/menu.svg',
                          height: 22,
                        ),
                      ),
                      14.widthBox,

                      // Greeting Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good Morning Emily',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
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

                      // Notification Bell Icon
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/svgs/notifications.svg',
                          height: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories & Workouts List
              FutureBuilder<List<CategoryModel>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No categories found.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  final categories = snapshot.data!;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = categories[index];
                      return _buildCategorySection(category);
                    }, childCount: categories.length),
                  );
                },
              ),

              // Bottom Spacing for Floating Navbar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(CategoryModel category) {
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
                    if (widget.onCategorySelected != null) {
                      widget.onCategorySelected!(category);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryDetailScreen(category: category),
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
                    if (widget.onWorkoutSelected != null) {
                      widget.onWorkoutSelected!(workout);
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailScreen(workout: workout),
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

