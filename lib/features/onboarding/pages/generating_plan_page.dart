import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_button.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../my_app.dart'; // To access rootNavigatorKey or we can just pop
import '../../splash/splash_screen.dart'; // Or wherever we go next

class GeneratingPlanPage extends StatefulWidget {
  const GeneratingPlanPage({super.key});

  @override
  State<GeneratingPlanPage> createState() => _GeneratingPlanPageState();
}

class _GeneratingPlanPageState extends State<GeneratingPlanPage> {
  @override
  void initState() {
    super.initState();
    // Simulate generation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<OnboardingProvider>().completeOnboarding();
        // Go to Home (for now redirect to Splash or a dummy Home)
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Home Screen")))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF92A3FD)),
          SizedBox(height: 30.h),
          Text(
            "Generating your personalized plan...",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Text(
            "This will only take a moment",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

