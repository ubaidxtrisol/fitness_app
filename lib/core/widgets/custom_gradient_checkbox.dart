import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomGradientCheckbox extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final double size;

  const CustomGradientCheckbox({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    Widget checkbox = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF7299), AppColors.primary],
              )
            : null,
        color: isSelected ? null : Colors.transparent,
        border: isSelected
            ? null
            : Border.all(color: const Color(0xFFD4D4D4), width: 1.5),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: size * 0.65, color: Colors.white)
          : null,
    );

    if (onChanged != null) {
      return GestureDetector(
        onTap: () => onChanged!(!isSelected),
        behavior: HitTestBehavior.opaque,
        child: checkbox,
      );
    }

    return checkbox;
  }
}
