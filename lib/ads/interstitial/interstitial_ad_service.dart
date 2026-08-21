import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../remote/remote_config.dart';

class InterstitialAdService {
  static final InterstitialAdService _instance = InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();

  int _clickCount = 0;
  InterstitialAd? _delayedAd;

  /// Main method to show an interstitial ad dynamically based on click gap and premium status.
  void showInterstitialAd({
    required BuildContext context,
    required bool isPremium,
    bool forceShow = false,
    required VoidCallback onComplete,
  }) {
    // 1. Premium Check
    if (isPremium) {
      onComplete();
      return;
    }

    // 2. Click Gap Logic
    if (!forceShow) {
      _clickCount++;
      if (_clickCount < remoteConfig.interClickGap) {
        onComplete();
        return;
      }
    }

    final adUnitId = remoteConfig.adIdInterstitial;
    if (adUnitId.isEmpty) {
      onComplete();
      return;
    }

    // Check if we have a delayed ad that loaded late from a previous timeout
    if (_delayedAd != null) {
      final ad = _delayedAd!;
      _delayedAd = null;

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('Delayed InterstitialAd failed to show: $error');
          ad.dispose();
          onComplete();
        },
      );

      _clickCount = 0;
      ad.show();
      return;
    }

    // 3. Show Loading Dialog immediately
    bool isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // Use root navigator to reliably close dialogs over tabs
      builder: (BuildContext dialogContext) {
        return const PopScope(
          canPop: false, // Prevent user from hitting Android back button during load
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ).then((_) {
      isDialogShowing = false;
    });

    // 4. Timeout Handler
    Timer? timeoutTimer;
    bool hasHandledCallback = false;

    void cleanupAndComplete() {
      if (!hasHandledCallback) {
        hasHandledCallback = true;
        if (isDialogShowing) {
          // Reliable way to close the dialog
          Navigator.of(context, rootNavigator: true).pop();
        }
        onComplete();
      }
    }

    // Start the timeout countdown based on Remote Config
    timeoutTimer = Timer(Duration(seconds: remoteConfig.interstitialLoadingTime), () {
      debugPrint('InterstitialAd load timed out.');
      // 5. If timeout happens before ad loads, close dialog and proceed.
      // Note: AdMob doesn't support canceling a load request, so we will dispose it
      // when it eventually arrives if it's too late.
      cleanupAndComplete();
    });

    // 6. Request Ad (Strictly NO Preloading)
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          timeoutTimer?.cancel();

          // If the timeout already occurred, save this late ad for next time.
          if (hasHandledCallback) {
            debugPrint('InterstitialAd loaded late. Saving for next click.');
            _delayedAd = ad;
            return;
          }

          // Close the loading dialog
          if (isDialogShowing) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              cleanupAndComplete();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              debugPrint('InterstitialAd failed to show: $error');
              ad.dispose();
              cleanupAndComplete();
            },
          );

          // Reset the click gap counter since an ad is successfully shown
          _clickCount = 0;
          
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          timeoutTimer?.cancel();
          cleanupAndComplete();
        },
      ),
    );
  }
}

final interstitialAdService = InterstitialAdService();
