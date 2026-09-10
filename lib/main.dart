import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/services/firebase/fa_services.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:fitness_app/features/onboarding/onboarding_screen.dart';
import 'package:fitness_app/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_ads_sdk/shared_ads_sdk.dart';

import 'fitness_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Loads .env (PILATES_API_KEY / PILATES_API_BASE_URL — see ApiEndpoints).
  // isOptional so a fresh checkout without a local .env still runs; the API
  // layer falls back to cached/bundled data when the key is missing.
  await dotenv.load(fileName: '.env', isOptional: true);

  await storage.init();

  // Opens (and on first run creates + seeds) the local Drift/sqflite database.
  await AppDatabase.instance.customSelect('SELECT 1').get();
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase (Assuming firebase_options.dart might be added later if missing,
  // Using try-catch to allow the app to run without crashing if not fully setup yet)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  final adsJson = await rootBundle.loadString('assets/json/ads_config.json');
  final adsConfig = AdsModel.fromJson(jsonDecode(adsJson));

  await SharedAds.instance.initialize(
    config: adsConfig,
    options: AdsSdkOptions(
      analytics: CallbackAdsAnalytics(FAServices.instance.logEvent),
      isFirstTime: false,
      traceAdIds: false,
      splashInterstitialWaitTime: 8,
      navigatorKey: Ctx.navigatorKey,
      verboseLogging: true,
      trackingAuthorized: true,
      loadingOverlayBuilder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, tileMode: .clamp, sigmaY: 10),
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
      routeGate: AdsRouteGate(
        blockWhenRouteUnknown: false,
        blockedRoutes: {
          SplashScreen().runtimeType.toString(),
          OnBoardingScreen().runtimeType.toString(),
        },
      ),
    ),
  );

  runApp(FitnessApp());
}
