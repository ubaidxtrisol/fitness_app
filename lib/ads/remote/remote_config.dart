import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  // Singleton pattern
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Keys for Remote Config parameters
  static const String _keyInterClickGap = 'inter_click_gap';
  static const String _keySplashTime = 'splash_time';
  static const String _keyInterstitialLoadingTime = 'interstitial_loading_time';
  static const String _keyAdIdInterstitial = 'ad_id_interstitial';
  static const String _keyAdIdAppOpen = 'ad_id_appopen';
  static const String _keyAdIdBanner = 'ad_id_banner';
  static const String _keyAdIdNative = 'ad_id_native';
  static const String _keyAdStatus = 'ad_status';

  /// Initialize Remote Config
  Future<void> initialize() async {
    try {
      // Set default values before fetching
      await _remoteConfig.setDefaults(const {
        _keyInterClickGap: 3, // example default in seconds or clicks
        _keySplashTime: 3, // example default in seconds
        _keyInterstitialLoadingTime: 2, // example default in seconds
        _keyAdIdInterstitial: '',
        _keyAdIdAppOpen: '',
        _keyAdIdBanner: '',
        _keyAdIdNative: '',
        _keyAdStatus: 0, // 0 = test ads, 1 = remote ads
      });

      // Configure settings (fetch interval)
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 12),
        // Use a low minimum fetch interval for development, but increase for production (e.g., 12 hours)
        minimumFetchInterval: kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 12),
      ));

      // Fetch and activate the configuration
      await _remoteConfig.fetchAndActivate();

      debugPrint('RemoteConfig initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize RemoteConfig: $e');
    }
  }

  // Getters for Remote Config values

  /// Gap between interstitial ad clicks (could be time or action count)
  int get interClickGap => _remoteConfig.getInt(_keyInterClickGap);

  /// Duration to show the splash screen (in seconds)
  int get splashTime => _remoteConfig.getInt(_keySplashTime);

  /// Time to wait for an interstitial ad to load (in seconds)
  int get interstitialLoadingTime => _remoteConfig.getInt(_keyInterstitialLoadingTime);

  /// Ad status (0 = test ads, 1 = live ads from remote config)
  int get adStatus => _remoteConfig.getInt(_keyAdStatus);

  /// Interstitial Ad Unit ID
  String get adIdInterstitial {
    if (adStatus == 0) {
      return Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544/1033173712' 
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return _remoteConfig.getString(_keyAdIdInterstitial);
  }

  /// App Open Ad Unit ID
  String get adIdAppOpen {
    if (adStatus == 0) {
      return Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544/9257395921' 
          : 'ca-app-pub-3940256099942544/5575463023';
    }
    return _remoteConfig.getString(_keyAdIdAppOpen);
  }

  /// Banner Ad Unit ID
  String get adIdBanner {
    if (adStatus == 0) {
      return Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544/6300978111' 
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return _remoteConfig.getString(_keyAdIdBanner);
  }

  /// Native Ad Unit ID
  String get adIdNative {
    if (adStatus == 0) {
      return Platform.isAndroid 
          ? 'ca-app-pub-3940256099942544/2247696110' 
          : 'ca-app-pub-3940256099942544/3986624511';
    }
    return _remoteConfig.getString(_keyAdIdNative);
  }
}

/// A global instance for super easy access anywhere in the app.
/// Just import this file and use: `remoteConfig.splashTime`
final remoteConfig = RemoteConfigService();
