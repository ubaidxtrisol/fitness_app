import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgeSliderWidget extends StatefulWidget {
  final int initialAge;
  final int minAge;
  final int maxAge;
  final ValueChanged<int> onAgeChanged;

  const AgeSliderWidget({
    super.key,
    this.initialAge = 28,
    this.minAge = 14,
    this.maxAge = 90,
    required this.onAgeChanged,
  });

  @override
  State<AgeSliderWidget> createState() => _AgeSliderWidgetState();
}

class _AgeSliderWidgetState extends State<AgeSliderWidget> {
  late int _selectedAge;
  late final ScrollController _scrollController;
  static const double _itemWidth = 90.0;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialAge;

    final initialIndex = _selectedAge - widget.minAge;
    final initialOffset = initialIndex * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final index = (offset / _itemWidth).round();
    final clampedIndex = index.clamp(0, widget.maxAge - widget.minAge);
    final newAge = widget.minAge + clampedIndex;

    if (newAge != _selectedAge) {
      setState(() {
        _selectedAge = newAge;
      });
      HapticFeedback.selectionClick();
      widget.onAgeChanged(newAge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 40;
    final horizontalPadding = (screenWidth - _itemWidth) / 2;
    final int currentYear = DateTime.now().year;
    final int birthYear = currentYear - _selectedAge;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Age Wheel with Fixed Center Highlight Bubble
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Fixed Center Pink Circle Bubble
                IgnorePointer(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF6F8FC),
                      border: Border.all(color: AppColors.border, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scrollable Numbers on top of the fixed background
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      _onScroll();
                    } else if (notification is ScrollEndNotification) {
                      final index = (_scrollController.offset / _itemWidth)
                          .round();
                      final targetOffset = index * _itemWidth;
                      if ((_scrollController.offset - targetOffset).abs() >
                          0.5) {
                        _scrollController.animateTo(
                          targetOffset,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                    return true;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding > 0
                          ? horizontalPadding
                          : 130,
                    ),
                    itemCount: widget.maxAge - widget.minAge + 1,
                    itemExtent: _itemWidth,
                    itemBuilder: (context, index) {
                      final ageVal = widget.minAge + index;
                      final isSelected = ageVal == _selectedAge;

                      return Center(
                        child: Text(
                          '$ageVal',
                          style: TextStyle(
                            fontFamily: 'Nexa',
                            fontSize: isSelected ? 42 : 32,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w700,
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFC7CDD8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          32.heightBox,

          // Born In Year Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Born in $birthYear',
              style: const TextStyle(
                fontFamily: 'Nexa',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
