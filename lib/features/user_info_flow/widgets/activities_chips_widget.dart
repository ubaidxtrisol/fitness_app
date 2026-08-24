import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ActivitiesOption {
  final String id;
  final String title;

  const ActivitiesOption({
    required this.id,
    required this.title,
  });
}

class ActivitiesChipsWidget extends StatelessWidget {
  final List<ActivitiesOption> options;
  final List<String> selectedList;
  final ValueChanged<List<String>> onChanged;

  const ActivitiesChipsWidget({
    super.key,
    required this.options,
    required this.selectedList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 14,
          children: options.map((opt) {
            final isSelected = selectedList.contains(opt.id);

            return GestureDetector(
              onTap: () {
                final updated = List<String>.from(selectedList);
                if (isSelected) {
                  updated.remove(opt.id);
                } else {
                  updated.add(opt.id);
                }
                onChanged(updated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFE8ECF2),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  opt.title,
                  style: TextStyle(
                    fontFamily: 'Nexa',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
