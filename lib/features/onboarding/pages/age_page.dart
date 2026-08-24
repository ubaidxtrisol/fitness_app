import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/number_picker_widget.dart';

class AgePage extends StatelessWidget {
  const AgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("How old are you?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("This helps us create your personalized plan", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 14,
            maxValue: 100,
            initialValue: provider.age ?? 25,
            onChanged: (val) => context.read<OnboardingProvider>().setAge(val),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.age == null) provider.setAge(25);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

