import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

enum NativeAdType {
  small,
  medium,
  large,
}

class NativeAdService {
  static final NativeAdService _instance = NativeAdService._internal();
  factory NativeAdService() => _instance;
  NativeAdService._internal();

  /// Returns the corresponding factory ID string mapped to Android Kotlin implementations
  String _getFactoryId(NativeAdType type) {
    switch (type) {
      case NativeAdType.small:
        return 'SmallNativeAdFactory';
      case NativeAdType.medium:
        return 'MediumNativeAdFactory';
      case NativeAdType.large:
        return 'LargeNativeAdFactory';
    }
  }

  /// The main entry point to get a Native Ad widget.
  /// Handles premium check, auto refresh, and optimized caching.
  Widget getNativeAd({
    required String adUnitId,
    required NativeAdType type,
    required bool isPremium,
    bool autoRefresh = true,
  }) {
    if (isPremium || adUnitId.isEmpty) {
      // Don't request or show ads for premium users (saves bandwidth/requests)
      return const SizedBox.shrink();
    }

    return _NativeAdWidget(
      adUnitId: adUnitId,
      type: type,
      autoRefresh: autoRefresh,
      service: this,
    );
  }
}

final nativeAdService = NativeAdService();

/// A stateful wrapper that handles auto-refreshing and rendering of the Native Ad
class _NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final NativeAdType type;
  final bool autoRefresh;
  final NativeAdService service;

  const _NativeAdWidget({
    required this.adUnitId,
    required this.type,
    required this.autoRefresh,
    required this.service,
  });

  @override
  State<_NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<_NativeAdWidget> {
  NativeAd? _currentAd;
  bool _isLoaded = false;
  Timer? _refreshTimer;
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    _loadAd();

    if (widget.autoRefresh) {
      // Auto refresh every 45 seconds to keep show rates high and fresh
      _refreshTimer = Timer.periodic(const Duration(seconds: 45), (_) {
        _loadAd();
      });
    }
  }

  void _loadAd() {
    final newAd = NativeAd(
      adUnitId: widget.adUnitId,
      factoryId: widget.service._getFactoryId(widget.type),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _currentAd?.dispose(); // Clean up old ad
              _currentAd = ad as NativeAd;
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
    );
    newAd.load();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _currentAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assign appropriate height constraints based on layout type
    double height;
    switch (widget.type) {
      case NativeAdType.small:
        height = 130.0;
        break;
      case NativeAdType.medium:
        height = 200.0;
        break;
      case NativeAdType.large:
        height = 340.0;
        break;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Detect theme change at runtime and trigger a fresh native ad reload
    final currentBrightness = Theme.of(context).brightness;
    if (_lastBrightness != null && _lastBrightness != currentBrightness) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadAd();
      });
    }
    _lastBrightness = currentBrightness;

    if (!_isLoaded || _currentAd == null) {
      // Return a shimmer skeleton while loading to prevent layout jumps
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: height,
          maxHeight: height,
        ),
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: height,
        maxHeight: height,
      ),
      child: AdWidget(
        key: ValueKey(_currentAd.hashCode),
        ad: _currentAd!,
      ),
    );
  }
}
