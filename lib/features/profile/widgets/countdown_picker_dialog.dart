import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountdownPickerDialog extends StatefulWidget {
  final int initialSeconds;
  final int minSeconds;
  final int maxSeconds;
  final ValueChanged<int> onSave;

  const CountdownPickerDialog({
    super.key,
    this.initialSeconds = 5,
    this.minSeconds = 1,
    this.maxSeconds = 120,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    int initialSeconds = 5,
    int minSeconds = 1,
    int maxSeconds = 120,
    required ValueChanged<int> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CountdownPickerDialog(
        initialSeconds: initialSeconds,
        minSeconds: minSeconds,
        maxSeconds: maxSeconds,
        onSave: onSave,
      ),
    );
  }

  @override
  State<CountdownPickerDialog> createState() => _CountdownPickerDialogState();
}

class _CountdownPickerDialogState extends State<CountdownPickerDialog> {
  late final ValueNotifier<int> _selectedSeconds;
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final clampedInitial = widget.initialSeconds.clamp(
      widget.minSeconds,
      widget.maxSeconds,
    );
    _selectedSeconds = ValueNotifier<int>(clampedInitial);
    _scrollController = FixedExtentScrollController(
      initialItem: clampedInitial - widget.minSeconds,
    );
  }

  @override
  void dispose() {
    _selectedSeconds.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.maxSeconds - widget.minSeconds + 1;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Countdown before workout',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03042C),
              ),
            ),
            20.heightBox,

            // Vertical Wheel Picker Container
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F1F1)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center selection highlight pill
                  Positioned(
                    left: 12,
                    right: 12,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Cupertino Wheel Scroll View
                  ValueListenableBuilder<int>(
                    valueListenable: _selectedSeconds,
                    builder: (context, selectedSec, _) {
                      return CupertinoPicker.builder(
                        scrollController: _scrollController,
                        itemExtent: 44,
                        selectionOverlay: const SizedBox.shrink(),
                        squeeze: 1.1,
                        diameterRatio: 1.5,
                        onSelectedItemChanged: (index) {
                          _selectedSeconds.value = widget.minSeconds + index;
                        },
                        childCount: totalItems,
                        itemBuilder: (context, index) {
                          final sec = widget.minSeconds + index;
                          final isSelected = sec == selectedSec;

                          return Center(
                            child: Text(
                              isSelected ? '${sec}s' : '$sec',
                              style: TextStyle(
                                fontFamily: 'Nexa',
                                fontSize: isSelected ? 22 : 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFC4C4C4),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            24.heightBox,

            // Cancel and Save Buttons
            Row(
              children: [
                // Cancel Button
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

                // Save Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSave(_selectedSeconds.value);
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
