import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/utils/app_toasts.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:fitness_app/features/home/widgets/body_focus_widget.dart';
import 'package:fitness_app/features/home/widgets/challenge_card_widget.dart';
import 'package:fitness_app/features/home/widgets/home_hero_banner.dart';
import 'package:fitness_app/features/home/widgets/today_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodaySummaryModel _todaySummary = const TodaySummaryModel(
    calories: 234,
    minutes: 25,
    workoutsCount: 4,
    streakDays: 6,
  );

  final List<ChallengeModel> _challenges = const [
    ChallengeModel(
      id: 'ch_wall_pilates',
      title: 'WALL PILATES',
      daysLabel: '14 Days',
      userCount: '244 User',
      thumbnailUrl:
          'https://cdn.pixabay.com/photo/2017/04/25/14/02/pilates-2259763_960_720.jpg',
    ),
    ChallengeModel(
      id: 'ch_tai_chi',
      title: 'TAI CHI',
      daysLabel: '28 Days',
      userCount: '244 User',
      thumbnailUrl:
          'https://cdn.pixabay.com/photo/2017/04/25/14/02/pilates-2259763_960_720.jpg',
    ),
    ChallengeModel(
      id: 'ch_pilate_busymom',
      title: 'PILATE BUSYMOM',
      daysLabel: '28 Days',
      userCount: '244 User',
      thumbnailUrl:
          'https://cdn.pixabay.com/photo/2017/04/25/14/02/pilates-2259763_960_720.jpg',
    ),
  ];

  final List<BodyFocusModel> _bodyFocusItems = const [
    BodyFocusModel(
      id: 'butt_leg',
      title: 'Butt & Leg',
      imagePath: 'assets/images/butNleg.png',
    ),
    BodyFocusModel(
      id: 'abs',
      title: 'Abs',
      imagePath: 'assets/images/abss.png',
    ),
    BodyFocusModel(
      id: 'full_body',
      title: 'Full body',
      imagePath: 'assets/images/full_body_g.png',
    ),
    BodyFocusModel(id: 'arm', title: 'Arm', imagePath: 'assets/images/arm.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
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

            // 1. Hero Banner
            SliverToBoxAdapter(
              child: HomeHeroBanner(
                onStartWorkout: () {
                  AppToast.success(
                    title: 'Success',
                    description: 'Workout started',
                  );
                },
              ),
            ),
            12.heightBox.sliver,

            // 2. Today Summary Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Today Summery',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            6.heightBox.sliver,
            SliverToBoxAdapter(
              child: TodaySummaryWidget(summary: _todaySummary),
            ),
            12.heightBox.sliver,

            // 3. Challenges Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Challenges',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
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
            ),
            12.heightBox.sliver,
            SliverToBoxAdapter(
              child: SizedBox(
                height: ChallengeCardWidget.height,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.none,
                  itemCount: _challenges.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10.956),
                  itemBuilder: (context, index) {
                    final challenge = _challenges[index];
                    return ChallengeCardWidget(
                      challenge: challenge,
                      onJoin: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Joined ${challenge.title}!'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            8.heightBox.sliver,

            // 4. Body Focus Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Body Focus',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            12.heightBox.sliver,
            SliverToBoxAdapter(
              child: BodyFocusWidget(items: _bodyFocusItems, onTap: (item) {}),
            ),

            // Bottom Spacing for Floating Bottom Bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}
