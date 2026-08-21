package com.example.fitness_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "SmallNativeAdFactory", SmallNativeAdFactory(context))
        
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "MediumNativeAdFactory", MediumNativeAdFactory(context))
            
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "LargeNativeAdFactory", LargeNativeAdFactory(context))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "SmallNativeAdFactory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "MediumNativeAdFactory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "LargeNativeAdFactory")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
