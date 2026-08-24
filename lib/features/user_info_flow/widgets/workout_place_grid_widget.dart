import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';

class WorkoutPlaceOption {
  final String id;
  final String title;
  final String imagePath;

  const WorkoutPlaceOption({
    required this.id,
    required this.title,
    required this.imagePath,
  });
}

class WorkoutPlaceGridWidget extends StatelessWidget {
  final List<WorkoutPlaceOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const WorkoutPlaceGridWidget({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.95,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final opt = options[index];
        final isSelected = selectedId == opt.id;

        return GestureDetector(
          onTap: () => onSelected(opt.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.border : AppColors.borderLight,
                width: 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFFF77992).withValues(alpha: 0.7),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration Image
                Expanded(
                  child: Image.asset(
                    opt.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
                12.heightBox,
                // Label
                Text(
                  opt.title,
                  style: const TextStyle(
                    fontFamily: 'Nexa',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
