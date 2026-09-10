import 'dart:developer';

import 'package:country_flags_pro/country_flags_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:fitness_app/features/language/models/languages.dart';
import 'package:fitness_app/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_ads_sdk/shared_ads_sdk.dart';

class LanguageScreen extends StatefulWidget {
  final bool isFromSettings;
  const LanguageScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final ValueNotifier<String?> selectedCode = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    selectedCode.value =
        EasyLocalization.of(Ctx.context!)?.currentLocale?.languageCode ?? 'en';
  }

  @override
  void dispose() {
    selectedCode.dispose();
    super.dispose();
  }

  void _onApplyLanguageSelection() async {
    storage.setBool(PrefsKeys.isFirstTime, true);
    final lang = languages.firstWhere(
      (lan) => lan.code == selectedCode.value,
      orElse: () =>
          const LanguageModel(code: 'en', country: 'US', name: 'English'),
    );

    log('Selected Language Execution: ${lang.name}');
    // await context.setLocale(Locale(lang.code));
    storage.setString(PrefsKeys.languageCode, selectedCode.value ?? 'en');

    if (mounted) {
      if (widget.isFromSettings) {
        context.pop();
      } else {
        context.pushReplacement(const OnBoardingScreen());
      }
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

            // Header with Globe illustration
            _buildHeader(),

            16.heightBox,

            // Language list
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: selectedCode,
                builder: (context, activeCode, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = activeCode == lang.code;

                      return GestureDetector(
                        onTap: () {
                          selectedCode.value = lang.code;
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.6)
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Flag Icon
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: ClipOval(
                                  child: CountryFlagsPro.getFlag(
                                    lang.country.toLowerCase(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              16.widthBox,

                              // Language Name
                              Expanded(
                                child: Text(
                                  lang.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),

                              // Selection Indicator (Radio / Check)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFF9E9E9E),
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom Save Button
            ValueListenableBuilder<String?>(
              valueListenable: selectedCode,
              builder: (context, activeCode, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: activeCode == null
                              ? null
                              : _onApplyLanguageSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      12.heightBox,
                      NativeAdWidget(placementId: 'language_screen'),
                    ],
                  ),
                );
              },
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
            'Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          // Spacer to keep title centered
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ==================== Header ====================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              4.heightBox,
              Text(
                'Choose your preferred language',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),

          // 3D Globe Image
          Image.asset(
            'assets/images/globe_tr.png',
            width: 120,
            height: 82,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
