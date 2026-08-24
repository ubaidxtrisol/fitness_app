import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ads/appopen/app_lifecycle_manager.dart';
import 'ads/remote/remote_config.dart';
import 'core/utils/shared_prefs_helper.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase (Assuming firebase_options.dart might be added later if missing,
  // Using try-catch to allow the app to run without crashing if not fully setup yet)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize Remote Config
  await remoteConfig.initialize();

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Initialize App Lifecycle Manager for On-Resume Ads
  AppLifecycleManager().initialize();

  // Initialize SharedPreferences
  await SharedPrefsHelper.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => OnboardingProvider())],
      child: const MyApp(),
    ),
  );
}
