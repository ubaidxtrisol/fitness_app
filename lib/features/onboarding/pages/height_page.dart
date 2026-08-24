import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/number_picker_widget.dart';

class HeightPage extends StatelessWidget {
  const HeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What's your height?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("This helps us create your personalized plan", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 100,
            maxValue: 250,
            initialValue: provider.height?.toInt() ?? 170,
            suffix: "cm",
            onChanged: (val) => context.read<OnboardingProvider>().setHeight(val.toDouble()),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.height == null) provider.setHeight(170.0);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

