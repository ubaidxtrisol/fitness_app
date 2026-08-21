import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../remote/remote_config.dart';
import '../../core/contants/constants.dart';
import '../interstitial/interstitial_ad_service.dart';

class AppOpenService {
  static final AppOpenService _instance = AppOpenService._internal();
  factory AppOpenService() => _instance;
  AppOpenService._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  DateTime? _appOpenLoadTime;

  /// Load an App Open Ad
  void loadAd() {
    // If ad is already loaded and valid, don't load again
    if (_appOpenAd != null && isAdAvailable) {
      return;
    }
    
    final adUnitId = remoteConfig.adIdAppOpen;
    if (adUnitId.isEmpty) {
      debugPrint('AppOpenAd adUnitId is empty from remote config');
      return;
    }

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd loaded successfully');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Whether an ad is available and not expired (App Open ads expire after 4 hours)
  bool get isAdAvailable {
    return _appOpenAd != null &&
        _appOpenLoadTime != null &&
        DateTime.now().subtract(const Duration(hours: 4)).isBefore(_appOpenLoadTime!);
  }

  /// Show the ad if one is available
  void showAdIfAvailable({VoidCallback? onAdDismissed, bool bypassStateCheck = false}) {
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      onAdDismissed?.call();
      return;
    }

    if (!bypassStateCheck && (Constants.isAppOpenAdShowing || Constants.isInterstitialAdShowing)) {
      debugPrint('Tried to show ad while already showing an ad.');
      onAdDismissed?.call();
      return;
    }

    Constants.isAppOpenAdShowing = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        Constants.isAppOpenAdShowing = true;
        interstitialAdService.resetClickCount();
        debugPrint('AppOpenAd showed fullscreen content.');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AppOpenAd failed to show fullscreen content: $error');
        _isShowingAd = false;
        Constants.isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AppOpenAd dismissed fullscreen content.');
        _isShowingAd = false;
        Constants.isAppOpenAdShowing = false;
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
      },
    );
    _appOpenAd!.show();
  }

  /// Load and show the ad immediately, returning a Future that completes when dismissed or failed
  Future<bool> loadAndShowImmediately() async {
    if (_isShowingAd || Constants.isAppOpenAdShowing || Constants.isInterstitialAdShowing) return false;

    // Lock the state so interstitial doesn't trigger while this is fetching
    Constants.isAppOpenAdShowing = true;

    if (isAdAvailable) {
      final completer = Completer<bool>();
      showAdIfAvailable(onAdDismissed: () {
        if (!completer.isCompleted) completer.complete(true);
      }, bypassStateCheck: true);
      return completer.future;
    }

    final adUnitId = remoteConfig.adIdAppOpen;
    if (adUnitId.isEmpty) {
      Constants.isAppOpenAdShowing = false;
      return false;
    }

    final completer = Completer<bool>();

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          
          showAdIfAvailable(onAdDismissed: () {
            if (!completer.isCompleted) completer.complete(true);
          }, bypassStateCheck: true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          Constants.isAppOpenAdShowing = false;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }
}

/// A global instance for easy access
final appOpenService = AppOpenService();
