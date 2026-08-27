import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fitness_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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

  runApp(FitnessApp());
}
