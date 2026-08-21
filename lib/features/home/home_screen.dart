import 'package:flutter/material.dart';
import '../../ads/banner/banner_ad_service.dart';
import '../../ads/interstitial/interstitial_ad_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleButtonPress(String buttonName) {
    interstitialAdService.showInterstitialAd(
      context: context,
      isPremium: false, // In a real app, this comes from user subscription status
      forceShow: false, // Setting to false enables the ad click gap logic
      onComplete: () {
        // This runs whether an ad was shown or skipped due to the click gap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action completed for $buttonName')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Fitness App!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _handleButtonPress('Button 1'),
              child: const Text('Test Action 1 (With Ad Gap)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleButtonPress('Button 2'),
              child: const Text('Test Action 2 (With Ad Gap)'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: bannerAdService.getBannerAd(
          isPremium: false,
          isCollapsible: true,
          collapsiblePosition: 'bottom',
        ),
      ),
    );
  }
}