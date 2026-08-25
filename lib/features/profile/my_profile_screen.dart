import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/profile/widgets/profile_slider_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // ValueNotifiers for reactive state management without setState
  final ValueNotifier<bool> _isMetric = ValueNotifier<bool>(true);
  final ValueNotifier<int> _height = ValueNotifier<int>(162); // cm or ft
  final ValueNotifier<int> _weight = ValueNotifier<int>(58); // kg or lbs
  final ValueNotifier<int> _targetWeight = ValueNotifier<int>(58); // kg or lbs

  @override
  void dispose() {
    _isMetric.dispose();
    _height.dispose();
    _weight.dispose();
    _targetWeight.dispose();
    super.dispose();
  }

  void _onUnitToggle(bool toMetric) {
    if (_isMetric.value == toMetric) return;

    if (toMetric) {
      // Imperial (lbs, ft) -> Metric (kg, cm)
      _weight.value = (_weight.value / 2.20462).round().clamp(30, 200);
      _targetWeight.value = (_targetWeight.value / 2.20462).round().clamp(30, 200);
      _height.value = (_height.value * 30.48).round().clamp(100, 230);
      _isMetric.value = true;
    } else {
      // Metric (kg, cm) -> Imperial (lbs, ft)
      _weight.value = (_weight.value * 2.20462).round().clamp(66, 440);
      _targetWeight.value = (_targetWeight.value * 2.20462).round().clamp(66, 440);
      _height.value = (_height.value / 30.48).round().clamp(3, 8);
      _isMetric.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),

            16.heightBox,

            // Unit Switcher (kg,cm vs lbs,ft)
            _buildUnitSwitcher(),

            20.heightBox,

            // Profile Settings Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Height Tile
                    ValueListenableBuilder<bool>(
                      valueListenable: _isMetric,
                      builder: (context, isMetric, _) {
                        return ValueListenableBuilder<int>(
                          valueListenable: _height,
                          builder: (context, heightVal, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/height.svg',
                              title: 'Height',
                              value: isMetric ? '$heightVal cm' : '$heightVal ft',
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Height',
                                  initialValue: heightVal,
                                  minValue: isMetric ? 100 : 3,
                                  maxValue: isMetric ? 230 : 8,
                                  unit: isMetric ? 'cm' : 'ft',
                                  onSave: (newVal) => _height.value = newVal,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.borderLight,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // Weight Tile
                    ValueListenableBuilder<bool>(
                      valueListenable: _isMetric,
                      builder: (context, isMetric, _) {
                        return ValueListenableBuilder<int>(
                          valueListenable: _weight,
                          builder: (context, weightVal, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/weight.svg',
                              title: 'Weight',
                              value: isMetric ? '${weightVal}kg' : '$weightVal lbs',
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Current Weight',
                                  initialValue: weightVal,
                                  minValue: isMetric ? 30 : 66,
                                  maxValue: isMetric ? 200 : 440,
                                  unit: isMetric ? 'kg' : 'lbs',
                                  onSave: (newVal) => _weight.value = newVal,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.borderLight,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // Target Weight Tile
                    ValueListenableBuilder<bool>(
                      valueListenable: _isMetric,
                      builder: (context, isMetric, _) {
                        return ValueListenableBuilder<int>(
                          valueListenable: _targetWeight,
                          builder: (context, targetWeightVal, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/target.svg',
                              title: 'Target Weight',
                              value: isMetric ? '${targetWeightVal}kg' : '$targetWeightVal lbs',
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Target Weight',
                                  initialValue: targetWeightVal,
                                  minValue: isMetric ? 30 : 66,
                                  maxValue: isMetric ? 200 : 440,
                                  unit: isMetric ? 'kg' : 'lbs',
                                  onSave: (newVal) => _targetWeight.value = newVal,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Top App Bar ====================
  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/arrow.svg',
                  width: 8,
                  height: 14,
                ),
              ),
            ),
          ),

          // Title
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          // Spacer for centering title
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ==================== Unit Switcher ====================
  Widget _buildUnitSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F1F1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: _isMetric,
          builder: (context, isMetric, _) {
            return Row(
              children: [
                // kg,cm button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onUnitToggle(true),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isMetric ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'kg,cm',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isMetric ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),

                // lbs,ft button
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onUnitToggle(false),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !isMetric ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'lbs,ft',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !isMetric ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== Profile Item Tile ====================
  Widget _buildProfileItem({
    required String svgPath,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 22,
              height: 22,
            ),
            14.widthBox,
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            6.widthBox,
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}

