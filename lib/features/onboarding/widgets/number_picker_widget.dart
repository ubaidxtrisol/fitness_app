import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberPickerWidget extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final String suffix;

  const NumberPickerWidget({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center highlight lines
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color(0xFF92A3FD).withOpacity(0.5), width: 2),
                bottom: BorderSide(color: const Color(0xFF92A3FD).withOpacity(0.5), width: 2),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 60.h,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(minValue + index);
            },
            controller: FixedExtentScrollController(
              initialItem: initialValue - minValue,
            ),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue - minValue + 1,
              builder: (context, index) {
                final value = minValue + index;
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D1617),
                        ),
                      ),
                      if (suffix.isNotEmpty) ...[
                        SizedBox(width: 4.w),
                        Text(
                          suffix,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7B6F72),
                          ),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
