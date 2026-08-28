import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:fitness_app/features/discover/services/pilates_remote_data_source.dart';
import 'package:flutter/services.dart';

/// Where a [DiscoverCatalogueResult]'s categories actually came from —
/// lets the UI show a small notice when it isn't live network data.
enum DiscoverDataSource { network, cache, bundledFallback }

class DiscoverCatalogueResult {
  final List<CategoryModel> categories;
  final DiscoverDataSource source;

  /// Non-fatal, human-readable context for [source] being cache/fallback
  /// instead of network — e.g. "You're offline — showing your last saved
  /// workouts." Null when [source] is network.
  final String? notice;

  const DiscoverCatalogueResult({
    required this.categories,
    required this.source,
    this.notice,
  });
}

/// The Discover catalogue: `GET /api/v1/pilates/categories` first, falling
/// back to the last locally-cached response, then to the bundled
/// `assets/json/pilates.json` — the same models either way, per
/// `readme-v3Nm.md`'s "same key names and types as ... pilates.json".
///
/// Never throws for "the network is down" — that's the expected case the
/// fallback chain exists for. It only throws if literally nothing is
/// available (no network, no cache, and the bundled asset itself fails to
/// parse), which should not happen in practice since the asset ships with
/// the app.
class DiscoverRepository {
  DiscoverRepository({PilatesRemoteDataSource? remote})
    : _remote = remote ?? PilatesRemoteDataSource();

  final PilatesRemoteDataSource _remote;

  /// [forceRefresh] skips the `If-None-Match` short-circuit (pull-to-refresh)
  /// but still updates the cache either way.
  Future<DiscoverCatalogueResult> getCategories({bool forceRefresh = false}) async {
    final cachedEtag = storage.getString(PrefsKeys.pilatesCategoriesEtag);

    try {
      final response = await _remote.fetchCategories(
        etag: forceRefresh || cachedEtag.isEmpty ? null : cachedEtag,
      );

      if (response.notModified) {
        final cached = _readCache();
        if (cached != null) {
          return DiscoverCatalogueResult(categories: cached, source: DiscoverDataSource.cache);
        }
        // The server thinks we have a copy but we don't (cache was cleared) —
        // fetch clean instead of returning nothing.
        final fresh = await _remote.fetchCategories();
        await _writeCache(fresh);
        return DiscoverCatalogueResult(
          categories: fresh.categories,
          source: DiscoverDataSource.network,
        );
      }

      await _writeCache(response);
      return DiscoverCatalogueResult(
        categories: response.categories,
        source: DiscoverDataSource.network,
      );
    } on ApiException catch (error) {
      developer.log('Falling back after API error: $error', name: 'DiscoverRepository');
      return _fallback(notice: error.message);
    } catch (error) {
      developer.log('Falling back after unexpected error: $error', name: 'DiscoverRepository');
      return _fallback(notice: const UnknownApiException().message);
    }
  }

  /// Local cache first (closest to what the user last actually saw), then
  /// the bundled catalogue.
  Future<DiscoverCatalogueResult> _fallback({required String notice}) async {
    final cached = _readCache();
    if (cached != null && cached.isNotEmpty) {
      return DiscoverCatalogueResult(
        categories: cached,
        source: DiscoverDataSource.cache,
        notice: '$notice Showing your last saved workouts.',
      );
    }

    final bundled = await _loadBundledAsset();
    if (bundled.isNotEmpty) {
      return DiscoverCatalogueResult(
        categories: bundled,
        source: DiscoverDataSource.bundledFallback,
        notice: '$notice Showing built-in workouts.',
      );
    }

    // Nothing at all worked — surface it rather than silently show an empty
    // screen with no explanation.
    throw const UnknownApiException(
      'Could not load workouts. Please check your connection and try again.',
    );
  }

  List<CategoryModel>? _readCache() {
    final raw = storage.getString(PrefsKeys.pilatesCategoriesCache);
    if (raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (error) {
      // A corrupt cache should never crash the app — just treat it as absent.
      developer.log('Ignoring corrupt categories cache: $error', name: 'DiscoverRepository');
      return null;
    }
  }

  Future<void> _writeCache(PilatesCategoriesResponse response) async {
    if (response.categories.isEmpty) return;
    try {
      await storage.setString(
        PrefsKeys.pilatesCategoriesCache,
        jsonEncode(response.categories.map((c) => c.toJson()).toList()),
      );
      if (response.etag != null && response.etag!.isNotEmpty) {
        await storage.setString(PrefsKeys.pilatesCategoriesEtag, response.etag!);
      }
    } catch (error) {
      // Caching is a best-effort convenience — never let a write failure
      // (full disk, etc.) bubble up and fail the actual load.
      developer.log('Failed to persist categories cache: $error', name: 'DiscoverRepository');
    }
  }

  Future<List<CategoryModel>> _loadBundledAsset() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/pilates.json');
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (error) {
      developer.log('Bundled catalogue failed to load: $error', name: 'DiscoverRepository');
      return [];
    }
  }
}
