import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../remote/remote_config.dart';

class BannerAdService {
  static final BannerAdService _instance = BannerAdService._internal();
  factory BannerAdService() => _instance;
  BannerAdService._internal();

  /// Returns a widget that automatically handles loading and displaying a Banner Ad.
  Widget getBannerAd({
    required bool isPremium,
    bool isCollapsible = false,
    String collapsiblePosition = 'bottom', // 'top' or 'bottom'
  }) {
    if (isPremium || remoteConfig.adIdBanner.isEmpty) {
      return const SizedBox.shrink();
    }

    return _BannerAdWidget(
      adUnitId: remoteConfig.adIdBanner,
      isCollapsible: isCollapsible,
      collapsiblePosition: collapsiblePosition,
    );
  }
}

final bannerAdService = BannerAdService();

class _BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final bool isCollapsible;
  final String collapsiblePosition;

  const _BannerAdWidget({
    required this.adUnitId,
    required this.isCollapsible,
    required this.collapsiblePosition,
  });

  @override
  State<_BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<_BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load ad only once per lifecycle, but we need MediaQuery which is only available here
    if (!_isLoaded && _bannerAd == null && !_isLoading) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    _isLoading = true;
    
    // Get anchored adaptive banner size dynamically based on screen width
    final size = MediaQuery.of(context).size;
    final adWidth = size.width.truncate();
    
    // Request anchored adaptive size
    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(adWidth) ?? AdSize.banner;
    
    if (!mounted) return;
    
    setState(() {
      _adSize = adSize;
    });

    final request = AdRequest(
      extras: widget.isCollapsible 
        ? {'collapsible': widget.collapsiblePosition} 
        : null,
    );

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: adSize,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoading = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If it failed to load and isn't loading anymore, return empty space
    if (_bannerAd == null && !_isLoading) {
      return const SizedBox.shrink(); 
    }

    final height = _adSize?.height.toDouble() ?? 50.0;
    final width = _adSize?.width.toDouble() ?? double.infinity;

    // While loading, show Shimmer skeleton
    if (!_isLoaded) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
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
            width: width,
            height: height,
            color: isDark ? Colors.grey[900] : Colors.white,
          ),
        ),
      );
    }

    // Fully loaded ad
    return SizedBox(
      width: width,
      height: height,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
