import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class DietPreferencePage extends StatelessWidget {
  const DietPreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final diets = ["Standard", "Vegetarian", "Vegan", "Keto", "Paleo"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Diet Preferences", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Select your preferred diet", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: diets.map((d) => OptionSelector(
                label: d,
                isSelected: provider.diet == d,
                onTap: () => provider.setDiet(d),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.diet != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

