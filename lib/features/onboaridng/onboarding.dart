import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../onboarding/providers/onboarding_provider.dart';

import '../onboarding/pages/intro_page.dart';
import '../onboarding/pages/gender_page.dart';
import '../onboarding/pages/age_page.dart';
import '../onboarding/pages/weight_page.dart';
import '../onboarding/pages/height_page.dart';
import '../onboarding/pages/goal_page.dart';
import '../onboarding/pages/activity_level_page.dart';
import '../onboarding/pages/focus_area_page.dart';
import '../onboarding/pages/workout_days_page.dart';
import '../onboarding/pages/diet_preference_page.dart';
import '../onboarding/pages/medical_conditions_page.dart';
import '../onboarding/pages/generating_plan_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: provider.pageController,
          physics: const NeverScrollableScrollPhysics(), // Users must use buttons
          onPageChanged: provider.onPageChanged,
          children: const [
            IntroPage(
              imagePath: 'assets/images/intro1.png',
              title: 'Welcome to Fitness',
              description: 'Start your fitness journey today. Track your workouts, set goals, and achieve results.',
            ),
            IntroPage(
              imagePath: 'assets/images/intro2.png',
              title: 'Track Progress',
              description: 'Log your meals, track your weight, and see your improvements over time.',
            ),
            IntroPage(
              imagePath: 'assets/images/intro3.png',
              title: 'Stay Motivated',
              description: 'Join challenges and earn badges to stay on track with your goals.',
            ),
            IntroPage(
              imagePath: 'assets/images/intro4.png',
              title: 'Get Ready',
              description: 'Let\'s set up your profile to give you a personalized experience.',
            ),
            GenderPage(),
            AgePage(),
            WeightPage(),
            HeightPage(),
            GoalPage(),
            ActivityLevelPage(),
            FocusAreaPage(),
            WorkoutDaysPage(),
            DietPreferencePage(),
            MedicalConditionsPage(),
            GeneratingPlanPage(),
          ],
        ),
      ),
    );
  }
}