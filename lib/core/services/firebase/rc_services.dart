import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService._(this._remoteConfig);

  static RemoteConfigService? _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      final config = FirebaseRemoteConfig.instance;
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );
      _instance = RemoteConfigService._(config);
    }
    return _instance!;
  }

  Future<void> initialize() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log('Remote Config Init Error: $e');
    }
  }

  /// Internal logic to pick the prefix
  String get _platformPrefix {
    if (kDebugMode) return 'dev_';
    if (kIsWeb) return 'web_';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android_';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return 'ios_';
      default:
        return 'dev_';
    }
  }

  /// The Generic "Do-It-All" Method
  /// Supports: [Map<String, dynamic>], [List<dynamic>], [bool], [int], [double], [String]
  T getPlatformValue<T>(String baseKey) {
    final dynamicKey = '$_platformPrefix$baseKey';
    final devKey = 'dev_$baseKey';

    // 1. Check if the dynamic key exists, otherwise fallback to dev
    final keyToUse = _remoteConfig.getAll().containsKey(dynamicKey)
        ? dynamicKey
        : devKey;
    try {
      // Handle JSON types (Maps and Lists)
      if (T == Map<String, dynamic>) {
        final rawJson = _remoteConfig.getString(keyToUse);
        if (rawJson.isEmpty) return <String, dynamic>{} as T;
        return jsonDecode(rawJson) as T;
      }

      if (T == List<dynamic>) {
        final rawJson = _remoteConfig.getString(keyToUse);
        if (rawJson.isEmpty) return [] as T;
        return jsonDecode(rawJson) as T;
      }

      // Handle Primitive types
      if (T == bool) return _remoteConfig.getBool(keyToUse) as T;
      if (T == int) return _remoteConfig.getInt(keyToUse) as T;
      if (T == double) return _remoteConfig.getDouble(keyToUse) as T;
      if (T == String) return _remoteConfig.getString(keyToUse) as T;

      throw Exception("Unsupported type requested: $T");
    } catch (e) {
      log('Error retrieving $keyToUse as $T: $e');
      return _getDefaultFallback<T>();
    }
  }

  /// Provides safe defaults if the fetch or parse fails
  T _getDefaultFallback<T>() {
    if (T == bool) return false as T;
    if (T == int) return 0 as T;
    if (T == double) return 0.0 as T;
    if (T == String) return "" as T;
    if (T == List) return [] as T;
    return <String, dynamic>{} as T;
  }
}
