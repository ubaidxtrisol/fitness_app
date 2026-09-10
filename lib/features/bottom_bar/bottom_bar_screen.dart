import 'dart:convert';

import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/features/discover/discover_screen.dart';
import 'package:fitness_app/features/home/views/home_screen.dart';
import 'package:fitness_app/features/profile/profile_screen.dart';
import 'package:fitness_app/features/progress/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_ads_sdk/shared_ads_sdk.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<_NavItem> _navItems = const [
    _NavItem(
      label: 'Home',
      svgPath: 'assets/svgs/home.svg',
      fillSvgPath: 'assets/svgs/home_fill.svg',
    ),
    _NavItem(
      label: 'Discover',
      svgPath: 'assets/svgs/discover.svg',
      fillSvgPath: 'assets/svgs/discover_fill.svg',
    ),
    _NavItem(
      label: 'Progress',
      svgPath: 'assets/svgs/progress.svg',
      fillSvgPath: 'assets/svgs/progress_fill.svg',
    ),
    _NavItem(
      label: 'Profile',
      svgPath: 'assets/svgs/profile.svg',
      fillSvgPath: 'assets/svgs/profile_fill.svg',
    ),
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder<int>(
        valueListenable: _currentIndex,
        builder: (context, currentIndex, child) {
          return IndexedStack(
            index: currentIndex,
            children: [
              const HomeScreen(),
              const DiscoverScreen(),
              const ProgressScreen(),
              const ProfileScreen(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final adsConfgi = await rootBundle.loadString(
            'assets/json/ads_config copy.json',
          );
          final configJson = jsonDecode(adsConfgi);

          SharedAds.instance.updateConfig(AdsModel.fromJson(configJson));
          setState(() {});
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, currentIndex, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isSelected = currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_currentIndex.value != index) {
                          _currentIndex.value = index;
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: SvgPicture.asset(
                              isSelected ? item.fillSvgPath : item.svgPath,
                              key: ValueKey<String>(
                                isSelected ? item.fillSvgPath : item.svgPath,
                              ),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          6.heightBox,
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String svgPath;
  final String fillSvgPath;

  const _NavItem({
    required this.label,
    required this.svgPath,
    required this.fillSvgPath,
  });
}
