import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class MedicalConditionsPage extends StatelessWidget {
  const MedicalConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final conditions = ["None", "Knee Pain", "Back Pain", "Heart Condition", "Other"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Medical Conditions", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("Any injuries or conditions we should know about?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: conditions.map((c) => OptionSelector(
                label: c,
                isSelected: provider.medicalConditions == c,
                onTap: () => provider.setMedicalConditions(c),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.medicalConditions != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

