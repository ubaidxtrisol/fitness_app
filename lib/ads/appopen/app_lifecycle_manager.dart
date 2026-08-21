import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'appopen_service.dart';
import '../../my_app.dart';
import '../../core/utils/loading_overlay.dart';
import '../../core/contants/constants.dart';

class AppLifecycleManager {
  static final AppLifecycleManager _instance = AppLifecycleManager._internal();

  factory AppLifecycleManager() => _instance;

  AppLifecycleManager._internal();

  bool _isInitialized = false;
  StreamSubscription<FGBGType>? _subscription;
  bool Function()? _isPremiumCallback;

  void initialize() {
    if (!_isInitialized) {
      _subscription = FGBGEvents.instance.stream.listen((event) {
        _handleFGBGEvent(event);
      });
      _isInitialized = true;
      debugPrint('AppLifecycleManager: Initialized with flutter_fgbg');
    }
  }

  /// Call this when your app's state (e.g., Provider/SharedPreferences) is ready
  void setPremiumCheck(bool Function() check) {
    _isPremiumCallback = check;
  }

  void dispose() {
    if (_isInitialized) {
      _subscription?.cancel();
      _subscription = null;
      _isInitialized = false;
      debugPrint('AppLifecycleManager: Disposed');
    }
  }

  void _handleFGBGEvent(FGBGType event) {
    debugPrint('AppLifecycleManager: FGBG Event: $event');

    switch (event) {
      case FGBGType.background:
        debugPrint('AppLifecycleManager: App went to background');
        break;

      case FGBGType.foreground:
        _handleAppResume();
        break;
    }
  }

  void _handleAppResume() async {
    debugPrint('AppLifecycleManager: App resumed');

    // Skip ad if user is premium
    if (_isPremiumCallback != null && _isPremiumCallback!()) {
      debugPrint('AppLifecycleManager: User is premium, skipping on-resume ad.');
      return;
    }

    // Skip if an interstitial is already loading or showing
    if (Constants.isInterstitialAdShowing || Constants.isAppOpenAdShowing) {
      debugPrint('AppLifecycleManager: Ad already showing/loading, skipping on-resume ad entirely.');
      return;
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      debugPrint('AppLifecycleManager: Navigator context not available');
      return;
    }

    LoadingOverlay.show(context);

    try {
      // Race between ad loading/showing and a 10s timeout
      final shown = await Future.any([
        appOpenService.loadAndShowImmediately(),
        Future.delayed(const Duration(seconds: 10), () => false),
      ]);

      debugPrint('AppLifecycleManager: Ad shown: $shown');
    } catch (e) {
      debugPrint('AppLifecycleManager: Error showing ad: $e');
    } finally {
      // Always hide overlay after ad or timeout
      LoadingOverlay.hide();
      debugPrint("AppLifecycleManager: Resume handling complete");
    }
  }
}
