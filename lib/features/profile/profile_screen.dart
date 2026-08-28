import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:fitness_app/features/home/widgets/today_summary_widget.dart';
import 'package:fitness_app/features/language/language_screen.dart';
import 'package:fitness_app/features/profile/my_profile_screen.dart';
import 'package:fitness_app/features/profile/workout_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProgressRepository _progress = ProgressRepository();
  TodaySummaryModel _todaySummary = const TodaySummaryModel(
    calories: 0,
    minutes: 0,
    workoutsCount: 0,
    streakDays: 0,
  );

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// Re-reads today's totals and the next suggested day. Called on mount and
  /// again whenever the user returns from a workout.
  Future<void> _refresh() async {
    final summary = await _progress.summaryForDay();

    if (!mounted) return;

    setState(() {
      _todaySummary = TodaySummaryModel(
        calories: summary.calories,
        minutes: summary.minutes,
        workoutsCount: summary.workouts,
        streakDays: summary.streakDays,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopAppBar(context),
              16.heightBox,
              _buildProfileHeader(),
              18.heightBox,
              _buildUserInfoRow(),
              20.heightBox,
              TodaySummaryWidget(summary: _todaySummary, padding: .zero),
              20.heightBox,
              _buildPremiumBanner(),
              24.heightBox,
              _buildSettingsSection(),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  // ==================== Top App Bar ====================
  Widget _buildTopAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Notifications Button
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/svgs/notifications.svg',
              width: 18,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Profile Header ====================
  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with edit badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4D4D4),
                border: Border.all(color: AppColors.primaryLight, width: 2),
              ),
              child: const Icon(Icons.person, size: 38, color: Colors.white),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/svgs/edit.svg',
                  width: 10,
                  height: 10,
                ),
              ),
            ),
          ],
        ),
        16.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              4.heightBox,
              const Text(
                'Manage Your Account and\nrefference',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== User Info Row ====================
  Widget _buildUserInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emily Johsan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            2.heightBox,
            const Text(
              'Emilyjason@gmail.com',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                6.widthBox,
                SvgPicture.asset('assets/svgs/edit.svg', width: 10, height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Go Premium Banner ====================
  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientStart.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Crown Icon in white circle
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset('assets/svgs/crown.svg'),
          ),
          12.widthBox,
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Go Premium',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                4.heightBox,
                Text(
                  'Unlock advanced insight ,\ncustom plan and more',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          8.widthBox,
          // Upgrade Button
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Upgrade',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Settings Section ====================
  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Setting',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        12.heightBox,
        // Group 1
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem(
                svgPath: 'assets/svgs/language.svg',
                title: 'Language',
                onTap: () {
                  Ctx.context?.push(const LanguageScreen(isFromSettings: true));
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
                indent: 16,
                endIndent: 16,
              ),
              _buildSettingItem(
                svgPath: 'assets/svgs/my_profile.svg',
                title: 'My Profile',
                onTap: () {
                  Ctx.context?.push(const MyProfileScreen());
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
                indent: 16,
                endIndent: 16,
              ),
              _buildSettingItem(
                svgPath: 'assets/svgs/work_out_setting.svg',
                title: 'Workout Setting',
                onTap: () {
                  Ctx.context?.push(const WorkoutSettingsScreen());
                },
              ),
            ],
          ),
        ),
        16.heightBox,
        // Group 2
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem(
                svgPath: 'assets/svgs/rate_us.svg',
                title: 'Rate us',
                onTap: () {},
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
                indent: 16,
                endIndent: 16,
              ),
              _buildSettingItem(
                svgPath: 'assets/svgs/privacy_policy.svg',
                title: 'Privacy Policy',
                onTap: () {},
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight,
                indent: 16,
                endIndent: 16,
              ),
              _buildSettingItem(
                svgPath: 'assets/svgs/share.svg',
                title: 'Share with friends',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String svgPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(svgPath, width: 24, height: 24),
            14.widthBox,
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
