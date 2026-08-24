import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

class IntroPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const IntroPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Placeholder for image
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(Icons.fitness_center, size: 100.sp, color: Colors.grey.shade400),
          ),
          SizedBox(height: 40.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          const Spacer(),
          OnboardingButton(
            text: "Next",
            onPressed: () => context.read<OnboardingProvider>().nextPage(),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

