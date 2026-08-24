import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';

class InjuryOption {
  final String id;
  final String title;
  final IconData icon;

  const InjuryOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class InjuriesGridWidget extends StatelessWidget {
  final List<InjuryOption> options;
  final List<String> selectedList;
  final ValueChanged<List<String>> onChanged;

  const InjuriesGridWidget({
    super.key,
    required this.options,
    required this.selectedList,
    required this.onChanged,
  });

  void _handleTap(String id) {
    final updated = List<String>.from(selectedList);

    if (id == 'none') {
      // If "None" is selected, clear everything else and keep only "None"
      updated.clear();
      updated.add('none');
    } else {
      // If selecting any specific injury, remove "None"
      updated.remove('none');

      if (updated.contains(id)) {
        updated.remove(id);
      } else {
        updated.add(id);
      }

      // If user unselected all, default back to 'none'
      if (updated.isEmpty) {
        updated.add('none');
      }
    }

    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    // Separate regular items and "None" item for centered bottom placement
    final regularOptions = options.where((o) => o.id != 'none').toList();
    final noneOption = options.firstWhere(
      (o) => o.id == 'none',
      orElse: () => const InjuryOption(
        id: 'none',
        title: 'None',
        icon: Icons.shield_outlined,
      ),
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // 3-column Grid for body part options
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemCount: regularOptions.length,
            itemBuilder: (context, index) {
              final opt = regularOptions[index];
              final isSelected = selectedList.contains(opt.id);

              return _buildCard(opt, isSelected);
            },
          ),
          12.heightBox,

          // Centered "None" button card in 3rd row
          SizedBox(
            width: (MediaQuery.of(context).size.width - 64) / 3,
            height: ((MediaQuery.of(context).size.width - 64) / 3) / 1.05,
            child: _buildCard(noneOption, selectedList.contains(noneOption.id)),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(InjuryOption opt, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleTap(opt.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              opt.icon,
              size: 28,
              color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
            ),
            8.heightBox,
            Text(
              opt.title,
              style: const TextStyle(
                fontFamily: 'Nexa',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
