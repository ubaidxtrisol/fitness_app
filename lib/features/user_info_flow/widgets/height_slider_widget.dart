import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HeightSliderWidget extends StatefulWidget {
  final int initialHeight;
  final int minHeight;
  final int maxHeight;
  final ValueChanged<int> onHeightChanged;

  const HeightSliderWidget({
    super.key,
    this.initialHeight = 165,
    this.minHeight = 120,
    this.maxHeight = 220,
    required this.onHeightChanged,
  });

  @override
  State<HeightSliderWidget> createState() => _HeightSliderWidgetState();
}

class _HeightSliderWidgetState extends State<HeightSliderWidget> {
  late int _selectedHeight;
  late final ScrollController _scrollController;
  static const double _itemHeight = 28.0;

  @override
  void initState() {
    super.initState();
    _selectedHeight = widget.initialHeight;

    final initialIndex = _selectedHeight - widget.minHeight;
    final initialOffset = initialIndex * _itemHeight;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final index = (offset / _itemHeight).round();
    final clampedIndex = index.clamp(0, widget.maxHeight - widget.minHeight);
    final newHeight = widget.minHeight + clampedIndex;

    if (newHeight != _selectedHeight) {
      setState(() {
        _selectedHeight = newHeight;
      });
      HapticFeedback.selectionClick();
      widget.onHeightChanged(newHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side: Big Selected Value & CM label
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_selectedHeight',
                style: const TextStyle(
                  fontFamily: 'Nexa',
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              8.heightBox,
              const Text(
                'CM',
                style: TextStyle(
                  fontFamily: 'Nexa',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        // Vertical Divider line
        Container(width: 1, height: 280, color: const Color(0xFFE5E7EB)),

        // Right Side: Interactive Ruler Scroll View with pointer
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 320,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Scrollable Ruler ticks and numbers
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      _onScroll();
                    } else if (notification is ScrollEndNotification) {
                      // Snap cleanly to nearest item
                      final index = (_scrollController.offset / _itemHeight)
                          .round();
                      final targetOffset = index * _itemHeight;
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
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 146,
                    ), // (320 - 28) / 2
                    itemCount: widget.maxHeight - widget.minHeight + 1,
                    itemExtent: _itemHeight,
                    itemBuilder: (context, index) {
                      final heightVal = widget.minHeight + index;
                      final isSelected = heightVal == _selectedHeight;
                      final isMajor = heightVal % 5 == 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isMajor)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                '$heightVal',
                                style: TextStyle(
                                  fontFamily: 'Nexa',
                                  fontSize: isSelected ? 18 : 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 42),

                          // Tick line
                          Container(
                            width: isSelected ? 32 : (isMajor ? 18 : 10),
                            height: isSelected ? 3 : 2,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFF6B7280),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 24),
                        ],
                      );
                    },
                  ),
                ),

                // Selected Indicator Arrow Pointer on the right edge
                Positioned(
                  right: 4,
                  child: CustomPaint(
                    size: const Size(10, 12),
                    painter: _TrianglePointerPainter(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePointerPainter extends CustomPainter {
  final Color color;

  _TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Points pointing left: <|
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePointerPainter oldDelegate) =>
      oldDelegate.color != color;
}
