import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final goals = ["Lose Weight", "Build Muscle", "Keep Fit", "Improve Flexibility"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What is your goal?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("It will help us to choose a best program for you", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          ...goals.map((g) => OptionSelector(
            label: g,
            isSelected: provider.goal == g,
            onTap: () => provider.setGoal(g),
          )),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.goal != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

