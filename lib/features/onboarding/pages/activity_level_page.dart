import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class ActivityLevelPage extends StatelessWidget {
  const ActivityLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final levels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Physical activity level?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Choose your regular activity level", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          ...levels.map((l) => OptionSelector(
            label: l,
            isSelected: provider.activityLevel == l,
            onTap: () => provider.setActivityLevel(l),
          )),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.activityLevel != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

