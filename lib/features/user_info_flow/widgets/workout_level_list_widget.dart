import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';

class WorkoutLevelOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const WorkoutLevelOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class WorkoutLevelListWidget extends StatelessWidget {
  final List<WorkoutLevelOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const WorkoutLevelListWidget({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (context, index) => 14.heightBox,
      itemBuilder: (context, index) {
        final opt = options[index];
        final isSelected = selectedId == opt.id;

        return GestureDetector(
          onTap: () => onSelected(opt.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.border : AppColors.borderLight,
                width: 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFFF77992).withValues(alpha: 0.6),
                    blurRadius: 6,
                    offset: Offset.zero,
                  )
                else
                  const BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFEFF4FA),
                  ),
                  child: Icon(
                    opt.icon,
                    size: 22,
                    color: isSelected ? Colors.white : const Color(0xFF8C98A8),
                  ),
                ),
                16.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt.title,
                        style: const TextStyle(
                          fontFamily: 'Nexa',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      4.heightBox,
                      Text(
                        opt.subtitle,
                        style: const TextStyle(
                          fontFamily: 'Nexa',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
