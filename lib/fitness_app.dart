import 'package:fitness_app/core/constants/app_theme.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Ctx.navigatorKey,
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SplashScreen(),
    );
  }
}
