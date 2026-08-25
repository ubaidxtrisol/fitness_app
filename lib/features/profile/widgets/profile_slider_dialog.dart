import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSliderDialog extends StatefulWidget {
  final String title;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String unit;
  final ValueChanged<int> onSave;

  const ProfileSliderDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required int initialValue,
    required int minValue,
    required int maxValue,
    required String unit,
    required ValueChanged<int> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ProfileSliderDialog(
        title: title,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        unit: unit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProfileSliderDialog> createState() => _ProfileSliderDialogState();
}

class _ProfileSliderDialogState extends State<ProfileSliderDialog> {
  late final ValueNotifier<int> _selectedValue;
  late final ScrollController _scrollController;
  static const double _itemWidth = 56.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier<int>(widget.initialValue);

    final initialIndex = widget.initialValue - widget.minValue;
    final initialOffset = initialIndex * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _selectedValue.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final index = (offset / _itemWidth).round();
    final clampedIndex = index.clamp(0, widget.maxValue - widget.minValue);
    final newVal = widget.minValue + clampedIndex;

    if (newVal != _selectedValue.value) {
      _selectedValue.value = newVal;
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03042C),
              ),
            ),
            20.heightBox,

            // Big Value Display
            ValueListenableBuilder<int>(
              valueListenable: _selectedValue,
              builder: (context, value, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$value',
                      style: const TextStyle(
                        fontFamily: 'Nexa',
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                    6.widthBox,
                    Text(
                      widget.unit,
                      style: const TextStyle(
                        fontFamily: 'Nexa',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                );
              },
            ),
            24.heightBox,

            // Horizontal Ruler Scroller
            SizedBox(
              height: 95,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding =
                      (constraints.maxWidth - _itemWidth) / 2;

                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            _onScroll();
                          } else if (notification is ScrollEndNotification) {
                            final index =
                                (_scrollController.offset / _itemWidth).round();
                            final targetOffset = index * _itemWidth;
                            if ((_scrollController.offset - targetOffset)
                                    .abs() >
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
                        child: ValueListenableBuilder<int>(
                          valueListenable: _selectedValue,
                          builder: (context, selectedVal, _) {
                            return ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              itemCount: widget.maxValue - widget.minValue + 1,
                              itemExtent: _itemWidth,
                              itemBuilder: (context, index) {
                                final currentVal = widget.minValue + index;
                                final isSelected = currentVal == selectedVal;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Number on top
                                    Text(
                                      '$currentVal',
                                      style: TextStyle(
                                        fontFamily: 'Nexa',
                                        fontSize: isSelected ? 17 : 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w900
                                            : FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.primary
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                    8.heightBox,

                                    // Tick line
                                    Container(
                                      width: isSelected ? 2.5 : 1.5,
                                      height: isSelected ? 24 : 16,
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
                            );
                          },
                        ),
                      ),

                      // Track with center pill indicator
                      Positioned(
                        bottom: 4,
                        left: 10,
                        right: 10,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            28.heightBox,

            // Cancel and Save Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF03042C),
                        ),
                      ),
                    ),
                  ),
                ),
                12.widthBox,

                // Save
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave(_selectedValue.value);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
