import 'package:flutter/material.dart';
import '../../ads/banner/banner_ad_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Welcome to Fitness App!'),
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