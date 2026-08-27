import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:flutter/material.dart';

class TodaySummaryWidget extends StatelessWidget {
  final TodaySummaryModel summary;

  const TodaySummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Calories
          Expanded(
            child: _buildItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xFFFF5C8C),
              iconBg: const Color(0xFFFFEEF3),
              title: '${summary.calories}',
              subtitle: 'Calories',
            ),
          ),
          _buildDivider(),

          // 2. Minutes
          Expanded(
            child: _buildItem(
              icon: Icons.access_time_rounded,
              iconColor: const Color(0xFF3B82F6),
              iconBg: const Color(0xFFEEF5FF),
              title: '${summary.minutes}',
              subtitle: '${summary.minutes} Minutes',
            ),
          ),
          _buildDivider(),

          // 3. Workout
          Expanded(
            child: _buildItem(
              icon: Icons.check_circle_outline_rounded,
              iconColor: const Color(0xFF22C55E),
              iconBg: const Color(0xFFE8F8EE),
              title: summary.workoutsCount.toString().padLeft(2, '0'),
              subtitle: 'Workout',
            ),
          ),
          _buildDivider(),

          // 4. Day Streak
          Expanded(
            child: _buildItem(
              icon: Icons.star_border_rounded,
              iconColor: const Color(0xFFF59E0B),
              iconBg: const Color(0xFFFEF3C7),
              title: summary.streakDays.toString().padLeft(2, '0'),
              subtitle: 'Day Streak',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 36, color: const Color(0xFFF1F3F7));
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        6.heightBox,
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        2.heightBox,
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8B7B80),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
