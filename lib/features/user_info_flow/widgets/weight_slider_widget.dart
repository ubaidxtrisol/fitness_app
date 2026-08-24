import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightSliderWidget extends StatefulWidget {
  final int initialWeight;
  final int minWeight;
  final int maxWeight;
  final ValueChanged<int> onWeightChanged;

  const WeightSliderWidget({
    super.key,
    this.initialWeight = 75,
    this.minWeight = 30,
    this.maxWeight = 200,
    required this.onWeightChanged,
  });

  @override
  State<WeightSliderWidget> createState() => _WeightSliderWidgetState();
}

class _WeightSliderWidgetState extends State<WeightSliderWidget> {
  late int _selectedWeight;
  late final ScrollController _scrollController;
  static const double _itemWidth = 56.0;

  @override
  void initState() {
    super.initState();
    _selectedWeight = widget.initialWeight;

    final initialIndex = _selectedWeight - widget.minWeight;
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
    final clampedIndex = index.clamp(0, widget.maxWeight - widget.minWeight);
    final newWeight = widget.minWeight + clampedIndex;

    if (newWeight != _selectedWeight) {
      setState(() {
        _selectedWeight = newWeight;
      });
      HapticFeedback.selectionClick();
      widget.onWeightChanged(newWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 40; // accounting for padding
    final horizontalPadding = (screenWidth - _itemWidth) / 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top Selected Value & kg
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$_selectedWeight',
              style: const TextStyle(
                fontFamily: 'Nexa',
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1.0,
              ),
            ),
            6.widthBox,
            const Text(
              'kg',
              style: TextStyle(
                fontFamily: 'Nexa',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        40.heightBox,

        // Interactive Horizontal Ruler
        SizedBox(
          height: 110,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Scrollable tick marks and numbers
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _onScroll();
                  } else if (notification is ScrollEndNotification) {
                    // Snap cleanly to nearest item
                    final index = (_scrollController.offset / _itemWidth).round();
                    final targetOffset = index * _itemWidth;
                    if ((_scrollController.offset - targetOffset).abs() > 0.5) {
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
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding > 0 ? horizontalPadding : 140),
                  itemCount: widget.maxWeight - widget.minWeight + 1,
                  itemExtent: _itemWidth,
                  itemBuilder: (context, index) {
                    final weightVal = widget.minWeight + index;
                    final isSelected = weightVal == _selectedWeight;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Number on top
                        Text(
                          '$weightVal',
                          style: TextStyle(
                            fontFamily: 'Nexa',
                            fontSize: isSelected ? 18 : 15,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        10.heightBox,

                        // Tick mark
                        Container(
                          width: isSelected ? 3 : 2,
                          height: isSelected ? 26 : 18,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF6B7280),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom subtle indicator track with active pill indicator
              Positioned(
                bottom: 8,
                left: 20,
                right: 20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background track line
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Center active pill marker
                    Container(
                      width: 44,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
