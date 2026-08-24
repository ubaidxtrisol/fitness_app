import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/option_selector.dart';

class FocusAreaPage extends StatelessWidget {
  const FocusAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final areas = ["Full Body", "Arm", "Chest", "Abs", "Leg"];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Focus Area", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("What area do you want to focus on?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView(
              children: areas.map((a) => OptionSelector(
                label: a,
                isSelected: provider.focusArea == a,
                onTap: () => provider.setFocusArea(a),
              )).toList(),
            ),
          ),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.focusArea != null) provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

