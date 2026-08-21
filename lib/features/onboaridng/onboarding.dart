import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../ads/native/native_ad_service.dart';
import '../../ads/remote/remote_config.dart';
import '../../ads/interstitial/interstitial_ad_service.dart';
import 'models/onboarding_data.dart';
import 'widgets/onboarding_page_content.dart';
import 'widgets/onboarding_controls.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Fitness',
      description: 'Start your fitness journey today. Track your workouts, set goals, and achieve results.',
      icon: Icons.fitness_center,
    ),
    OnboardingData(
      title: 'Track Progress',
      description: 'Log your meals, track your weight, and see your improvements over time with detailed charts.',
      icon: Icons.trending_up,
    ),
    OnboardingData(
      title: 'Stay Motivated',
      description: 'Join challenges, earn badges, and connect with a community that pushes you to be your best.',
      icon: Icons.local_fire_department,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Show Interstitial Ad before navigating to Home Screen
      interstitialAdService.showInterstitialAd(
        context: context,
        isPremium: false, // Hardcoded for now, replace with actual premium check
        forceShow: true, // Force show ad when finishing onboarding
        onComplete: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: colorScheme.primary, fontSize: 16),
                ),
              ),
            ),
            
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPageContent(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // Bottom controls (Dots & Next Button)
            OnboardingControls(
              pagesLength: _pages.length,
              currentPage: _currentPage,
              onNextPressed: _nextPage,
            ),
            
            // Large Native Ad at the bottom
            nativeAdService.getNativeAd(
              adUnitId: remoteConfig.adIdNative,
              type: NativeAdType.large,
              isPremium: false,
              autoRefresh: true,
            ),
          ],
        ),
      ),
    );
  }
}