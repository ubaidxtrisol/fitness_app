import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/repositories/settings_repository.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/profile/widgets/countdown_picker_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkoutSettingsScreen extends StatefulWidget {
  const WorkoutSettingsScreen({super.key});

  @override
  State<WorkoutSettingsScreen> createState() => _WorkoutSettingsScreenState();
}

class _WorkoutSettingsScreenState extends State<WorkoutSettingsScreen> {
  // ValueNotifiers for reactive state management without setState
  final ValueNotifier<bool> _isVoiceGuideEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isDetailedGuide = ValueNotifier<bool>(true);
  final ValueNotifier<double> _volume = ValueNotifier<double>(0.6);
  final ValueNotifier<bool> _isSoundEffectEnabled = ValueNotifier<bool>(true);
  final ValueNotifier<int> _countdownSeconds = ValueNotifier<int>(5);

  final SettingsRepository _settings = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final row = await _settings.load();
    if (!mounted) return;
    _isVoiceGuideEnabled.value = row.voiceGuideEnabled;
    _isDetailedGuide.value = row.detailedGuide;
    _volume.value = row.volume;
    _isSoundEffectEnabled.value = row.soundEffectEnabled;
    _countdownSeconds.value = row.countdownSeconds;
  }

  @override
  void dispose() {
    _isVoiceGuideEnabled.dispose();
    _isDetailedGuide.dispose();
    _volume.dispose();
    _isSoundEffectEnabled.dispose();
    _countdownSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar
              _buildTopAppBar(context),

              20.heightBox,

              // Voice Guide Section Header & Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Voice Guide',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isVoiceGuideEnabled,
                    builder: (context, isEnabled, _) {
                      return CupertinoSwitch(
                        value: isEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          _isVoiceGuideEnabled.value = val;
                          _settings.update(voiceGuideEnabled: val);
                        },
                      );
                    },
                  ),
                ],
              ),

              14.heightBox,

              // Detailed Guide vs Brief Guide Switcher
              _buildGuideTypeSwitcher(),

              10.heightBox,

              // Guide Subtitle
              ValueListenableBuilder<bool>(
                valueListenable: _isDetailedGuide,
                builder: (context, isDetailed, _) {
                  return Text(
                    isDetailed
                        ? 'Instructions, key points and breathing tips'
                        : 'Short voice prompts during workouts',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),

              18.heightBox,

              // Volume Slider
              _buildVolumeSlider(),

              24.heightBox,

              // Sound Effect & Countdown Card
              Container(
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
                    // Sound Effect Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sound effect',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isSoundEffectEnabled,
                            builder: (context, isSoundEnabled, _) {
                              return CupertinoSwitch(
                                value: isSoundEnabled,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  _isSoundEffectEnabled.value = val;
                                  _settings.update(soundEffectEnabled: val);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.borderLight,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // Countdown before workout Row
                    InkWell(
                      onTap: () {
                        CountdownPickerDialog.show(
                          context: context,
                          initialSeconds: _countdownSeconds.value,
                          minSeconds: 1,
                          maxSeconds: 120,
                          onSave: (val) {
                            _countdownSeconds.value = val;
                            _settings.update(countdownSeconds: val);
                          },
                        );
                      },
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Countdown before workout',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<int>(
                                  valueListenable: _countdownSeconds,
                                  builder: (context, seconds, _) {
                                    return Text(
                                      '${seconds}s',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                                4.widthBox,
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== Top App Bar ====================
  Widget _buildTopAppBar(BuildContext context) {
    return Row(
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
          'Workout Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        // Spacer for center balance
        const SizedBox(width: 40),
      ],
    );
  }

  // ==================== Guide Type Switcher ====================
  Widget _buildGuideTypeSwitcher() {
    return Container(
      height: 48,
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
        valueListenable: _isDetailedGuide,
        builder: (context, isDetailed, _) {
          return Row(
            children: [
              // Detailed Guide Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _isDetailedGuide.value = true;
                    _settings.update(detailedGuide: true);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDetailed
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Detailed Guide',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDetailed
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),

              // Brief Guide Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _isDetailedGuide.value = false;
                    _settings.update(detailedGuide: false);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !isDetailed
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Brief Guide',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: !isDetailed
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== Volume Slider ====================
  Widget _buildVolumeSlider() {
    return Row(
      children: [
        SvgPicture.asset('assets/svgs/volum_down.svg'),
        Expanded(
          child: ValueListenableBuilder<double>(
            valueListenable: _volume,
            builder: (context, vol, _) {
              return SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.primaryLight,
                  trackHeight: 6,
                  thumbColor: Colors.white,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                    elevation: 3,
                  ),
                  overlayColor: AppColors.primary.withValues(alpha: 0.15),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 18,
                  ),
                ),
                child: Slider(
                  value: vol,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (newVol) => _volume.value = newVol,
                  onChangeEnd: (newVol) => _settings.update(volume: newVol),
                ),
              );
            },
          ),
        ),
        SvgPicture.asset('assets/svgs/volumn_up.svg'),
      ],
    );
  }
}
