import 'package:fitness_app/core/utils/navigation_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/splash/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: RightToLeftPageTransitionsBuilder(),
        TargetPlatform.iOS: RightToLeftPageTransitionsBuilder(),
      },
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: rootNavigatorKey,
          title: 'Fitness App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE45881)),
            pageTransitionsTheme: pageTransitionsTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE45881),
            ),
            pageTransitionsTheme: pageTransitionsTheme,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}