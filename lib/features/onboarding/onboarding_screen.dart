import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/app_strings.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/widgets/selection_grid_card.dart';
import 'package:fitness_app/features/user_info_flow/user_info_flow_screen.dart';
import 'package:flutter/material.dart';

class OnboardingOption {
  final String id;
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingOption({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingStepData {
  final String title;
  final String subtitle;
  final bool showArrow;
  final List<OnboardingOption> options;

  const OnboardingStepData({
    required this.title,
    required this.subtitle,
    this.showArrow = true,
    required this.options,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Selected option ID for each step
  final Map<int, String> _selectedOptions = {
    0: 'get_in_shape',
    1: 'tone_arm',
    2: 'loose_weight',
  };

  late final List<OnboardingStepData> _steps = [
    // Step 1: Motivation
    OnboardingStepData(
      title: AppStrings.whatMotivatesYouTheMost,
      subtitle: AppStrings.chooseTheReasonThatInspireYou,
      showArrow: true,
      options: [
        OnboardingOption(
          id: 'get_in_shape',
          imagePath: 'assets/images/get_in_shape.png',
          title: AppStrings.getInShape,
          subtitle: AppStrings.getInShapeSubtitle,
        ),
        OnboardingOption(
          id: 'look_better',
          imagePath: 'assets/images/look_better.png',
          title: AppStrings.lookBetter,
          subtitle: AppStrings.lookBetterSubtitle,
        ),
        OnboardingOption(
          id: 'reduce_stress',
          imagePath: 'assets/images/reduce_stress.png',
          title: AppStrings.reduceStress,
          subtitle: AppStrings.reduceStressSubtitle,
        ),
        OnboardingOption(
          id: 'get_enough_sleep',
          imagePath: 'assets/images/get_enough_sleep.png',
          title: AppStrings.getEnoughSleep,
          subtitle: AppStrings.getEnoughSleepSubtitle,
        ),
        OnboardingOption(
          id: 'find_self_love',
          imagePath: 'assets/images/self_love.png',
          title: AppStrings.findSelfLove,
          subtitle: AppStrings.findSelfLoveSubtitle,
        ),
      ],
    ),

    // Step 2: Focus Area
    OnboardingStepData(
      title: AppStrings.whatIsYourMainGoal,
      subtitle: AppStrings.chooseTheReasonThatInspireYou,
      showArrow: true,
      options: [
        OnboardingOption(
          id: 'loose_weight',
          imagePath: 'assets/images/loose_weight.png',
          title: AppStrings.looseWeight,
          subtitle: AppStrings.getInShapeSubtitle,
        ),
        OnboardingOption(
          id: 'tone_muscle',
          imagePath: 'assets/images/tone_muscle.png',
          title: AppStrings.toneMuscle,
          subtitle: AppStrings.lookBetterSubtitle,
        ),
        OnboardingOption(
          id: 'improve_health',
          imagePath: 'assets/images/improve_health.png',
          title: AppStrings.improveHealth,
          subtitle: AppStrings.reduceStressSubtitle,
        ),
        OnboardingOption(
          id: 'improve_flexibility',
          imagePath: 'assets/images/improve_flexibility.png',
          title: AppStrings.improveFlexibility,
          subtitle: AppStrings.getEnoughSleepSubtitle,
        ),
        OnboardingOption(
          id: 'refine_posture',
          imagePath: 'assets/images/refine_posture.png',
          title: AppStrings.refinePosture,
          subtitle: AppStrings.findSelfLoveSubtitle,
        ),
      ],
    ),

    OnboardingStepData(
      title: AppStrings.pleaseChooseYourFocusArea,
      subtitle: AppStrings.getAPlanThatBestSuit,
      showArrow: false,
      options: [
        OnboardingOption(
          id: 'tone_arm',
          imagePath: 'assets/images/tone_arm.png',
          title: AppStrings.toneArm,
          subtitle: AppStrings.getInShapeSubtitle,
        ),
        OnboardingOption(
          id: 'flat_belly',
          imagePath: 'assets/images/flat_belly.png',
          title: AppStrings.flatBelly,
          subtitle: AppStrings.lookBetterSubtitle,
        ),
        OnboardingOption(
          id: 'round_butt',
          imagePath: 'assets/images/round_butt.png',
          title: AppStrings.roundButt,
          subtitle: AppStrings.reduceStressSubtitle,
        ),
        OnboardingOption(
          id: 'slim_leg',
          imagePath: 'assets/images/slim_leg.png',
          title: AppStrings.slimLeg,
          subtitle: AppStrings.getEnoughSleepSubtitle,
        ),
        OnboardingOption(
          id: 'full_body',
          imagePath: 'assets/images/full_body.png',
          title: AppStrings.fullBody,
          subtitle: AppStrings.findSelfLoveSubtitle,
        ),
      ],
    ),

    // Step 3: Main Goal
  ];

  void _onNextPressed() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.push(const UserInfoFlowScreen());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, stepIndex) {
                  final currentStep = _steps[stepIndex];
                  final selectedId = _selectedOptions[stepIndex];

                  return Column(
                    children: [
                      // Header Section
                      SizedBox(
                        height: 130,
                        child: Stack(
                          children: [
                            if (currentStep.showArrow)
                              Align(
                                alignment: const Alignment(1.1, 0),
                                child: Image.asset(
                                  'assets/images/ob_arrow.png',
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: currentStep.showArrow
                                        ? context.width * 0.6
                                        : context.width * 0.85,
                                    child: Text(
                                      currentStep.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: AppColors.textPrimary,
                                        height: 1.1,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  4.heightBox,
                                  Text(
                                    currentStep.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.heightBox,

                      // Grid Section
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: currentStep.options.length,
                          itemBuilder: (context, index) {
                            final item = currentStep.options[index];
                            final isSelected = selectedId == item.id;

                            return SelectionGridCard(
                              imagePath: item.imagePath,
                              title: item.title,
                              subtitle: item.subtitle,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedOptions[stepIndex] = item.id;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: _onNextPressed,

              child: Text(AppStrings.next),
            ),
          ],
        ),
      ),
    );
  }
}
