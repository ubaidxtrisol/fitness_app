import 'package:fitness_app/core/constants/app_theme.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:flutter/material.dart';
import 'package:shared_ads_sdk/shared_ads_sdk.dart';

import 'features/splash/splash_screen.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdsLifecycleScope(
      child: MaterialApp(
        navigatorKey: Ctx.navigatorKey,
        title: 'Fitness App',
        navigatorObservers: [AdsRouteObserver()],
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
