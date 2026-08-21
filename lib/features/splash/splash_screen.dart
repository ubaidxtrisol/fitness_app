import 'dart:async';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fitness_center, size: 80, color: Color(0xFFE45881)),
            SizedBox(height: 24),
            Text(
              'Fitness App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE45881),
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE45881)),
            ),
          ],
        ),
      ),
    );
  }
}