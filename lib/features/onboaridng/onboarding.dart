import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../ads/native/native_ad_service.dart';
import '../../ads/remote/remote_config.dart';
import '../../ads/interstitial/interstitial_ad_service.dart';

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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image / Icon
                            Icon(
                              _pages[index].icon,
                              size: 100, // Reduced from 150 to fit better with large ad
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 32), // Reduced from 60
                            // Title
                            Text(
                              _pages[index].title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24, // Slightly smaller
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16), // Reduced from 20
                            // Description
                            Text(
                              _pages[index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14, // Slightly smaller
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom controls (Dots & Next Button)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dot Indicator
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 8.0,
                            width: _currentPage == index ? 24.0 : 8.0,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? colorScheme.primary
                                  : colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                      // Next / Get Started Button
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}