import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../ads/appopen/appopen_service.dart';
import '../../ads/remote/remote_config.dart';
import '../onboaridng/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start loading the App Open Ad immediately
    appOpenService.loadAd();
    
    // Wait for splashTime from Remote Config. If config is still loading,
    // this will use the default value (e.g., 3 seconds).
    final splashTime = remoteConfig.splashTime > 0 ? remoteConfig.splashTime : 3;
    final duration = Duration(seconds: splashTime);
    
    _timer = Timer(duration, _onSplashTimeout);
  }

  void _onSplashTimeout() {
    if (_isNavigating) return;
    
    // Time out reached. Check if App Open Ad is available.
    // If found, show it. Then navigate when it's dismissed.
    if (appOpenService.isAdAvailable) {
      appOpenService.showAdIfAvailable(
        onAdDismissed: _navigateToNextScreen,
      );
    } else {
      // Ad is not available at timeout, navigate away.
      // This handles the show rate case: we don't waste the user's time waiting
      // longer than the splash timeout. If the ad loads later, it will be
      // kept in memory and shown via AppLifecycleReactor on next app resume.
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (_isNavigating) return;
    _isNavigating = true;
    _timer?.cancel();
    
    // Navigate to next screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
          ),
          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'assets/images/splash_illustration.png',
                  height: 300.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 40.h),
                Image.asset(
                  'assets/images/splash_logo.png',
                  width: 80.w,
                  height: 80.h,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Fitness App',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1617),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Move Better. Feel Stronger',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF7B6F72),
                  ),
                ),
                const Spacer(flex: 2),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF92A3FD)),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}