import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class GenderPage extends StatelessWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Tell us about yourself", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("To give you a better experience we need to know your gender", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 40.h),
          OptionSelector(
            label: "Male",
            icon: "👨",
            isSelected: provider.gender == "Male",
            onTap: () => provider.setGender("Male"),
          ),
          OptionSelector(
            label: "Female",
            icon: "👩",
            isSelected: provider.gender == "Female",
            onTap: () => provider.setGender("Female"),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.gender != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

