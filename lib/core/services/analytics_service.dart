import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsHelper {
  AnalyticsHelper._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logScreenView(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    const bool isDebug = kDebugMode;
    debugPrint("LogEvent: is debug: $eventName: $isDebug");
    if (!isDebug) {
      await _analytics.logEvent(name: eventName, parameters: parameters);
      debugPrint("LogEvent: $eventName");
    }
  }
}
