import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import '../widgets/number_picker_widget.dart';

class WorkoutDaysPage extends StatelessWidget {
  const WorkoutDaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Text("Workout Days", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Text("How many days a week do you want to train?", style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          const Spacer(),
          NumberPickerWidget(
            minValue: 1,
            maxValue: 7,
            initialValue: provider.workoutDays ?? 3,
            suffix: "Days",
            onChanged: (val) => context.read<OnboardingProvider>().setWorkoutDays(val),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () {
              if (provider.workoutDays == null) provider.setWorkoutDays(3);
              provider.nextPage();
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

