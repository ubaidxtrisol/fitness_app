import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'my_app.dart';
import 'ads/remote/remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

  runApp(const MyApp());
}