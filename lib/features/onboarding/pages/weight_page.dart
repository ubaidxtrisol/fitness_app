import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/number_picker_widget.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("What's your weight?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("You can always change this later", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 30,
            maxValue: 200,
            initialValue: provider.weight?.toInt() ?? 70,
            suffix: "kg",
            onChanged: (val) => context.read<OnboardingProvider>().setWeight(val.toDouble()),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.weight == null) provider.setWeight(70.0);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

