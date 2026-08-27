import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/repositories/user_profile_repository.dart';
import 'package:fitness_app/features/profile/unit_conversion.dart';
import 'package:fitness_app/features/profile/widgets/profile_slider_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final UserProfileRepository _profiles = UserProfileRepository();

  // Display unit only. The three values below are always metric.
  final ValueNotifier<bool> _isMetric = ValueNotifier<bool>(true);
  final ValueNotifier<int> _heightCm = ValueNotifier<int>(165);
  final ValueNotifier<int> _weightKg = ValueNotifier<int>(75);
  final ValueNotifier<int> _targetWeightKg = ValueNotifier<int>(70);

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Shows back what the user picked during the info flow.
  Future<void> _load() async {
    final profile = await _profiles.load();
    if (!mounted) return;

    _heightCm.value = profile.heightCm;
    _weightKg.value = profile.weightKg;
    _targetWeightKg.value = profile.targetWeightKg;
  }

  @override
  void dispose() {
    _isMetric.dispose();
    _heightCm.dispose();
    _weightKg.dispose();
    _targetWeightKg.dispose();
    super.dispose();
  }

  /// Flips the display unit only — the stored metric values never round-trip
  /// through a conversion, so toggling back and forth cannot drift.
  void _onUnitToggle(bool toMetric) => _isMetric.value = toMetric;

  Future<void> _saveHeight(int cm) async {
    _heightCm.value = cm;
    await _profiles.saveAnswers({'height': cm});
  }

  Future<void> _saveWeight(int kg) async {
    _weightKg.value = kg;
    await _profiles.saveAnswers({'weight': kg});
  }

  Future<void> _saveTargetWeight(int kg) async {
    _targetWeightKg.value = kg;
    await _profiles.saveAnswers({'target_weight': kg});
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
                          valueListenable: _heightCm,
                          builder: (context, heightCm, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/height.svg',
                              title: 'Height',
                              value: isMetric
                                  ? '$heightCm cm'
                                  : feetInches(heightCm),
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Height',
                                  initialValue: isMetric
                                      ? heightCm
                                      : cmToInches(heightCm),
                                  minValue: isMetric ? 100 : 39,
                                  maxValue: isMetric ? 230 : 91,
                                  unit: isMetric ? 'cm' : 'in',
                                  onSave: (newVal) => _saveHeight(
                                    isMetric ? newVal : inchesToCm(newVal),
                                  ),
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
                          valueListenable: _weightKg,
                          builder: (context, weightKg, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/weight.svg',
                              title: 'Weight',
                              value: isMetric
                                  ? '${weightKg}kg'
                                  : '${kgToLbs(weightKg)} lbs',
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Current Weight',
                                  initialValue: isMetric
                                      ? weightKg
                                      : kgToLbs(weightKg),
                                  minValue: isMetric ? 30 : 66,
                                  maxValue: isMetric ? 200 : 440,
                                  unit: isMetric ? 'kg' : 'lbs',
                                  onSave: (newVal) => _saveWeight(
                                    isMetric ? newVal : lbsToKg(newVal),
                                  ),
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
                          valueListenable: _targetWeightKg,
                          builder: (context, targetKg, _) {
                            return _buildProfileItem(
                              svgPath: 'assets/svgs/target.svg',
                              title: 'Target Weight',
                              value: isMetric
                                  ? '${targetKg}kg'
                                  : '${kgToLbs(targetKg)} lbs',
                              onTap: () {
                                ProfileSliderDialog.show(
                                  context: context,
                                  title: 'Target Weight',
                                  initialValue: isMetric
                                      ? targetKg
                                      : kgToLbs(targetKg),
                                  minValue: isMetric ? 30 : 66,
                                  maxValue: isMetric ? 200 : 440,
                                  unit: isMetric ? 'kg' : 'lbs',
                                  onSave: (newVal) => _saveTargetWeight(
                                    isMetric ? newVal : lbsToKg(newVal),
                                  ),
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

