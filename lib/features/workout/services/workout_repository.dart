import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/core/network/pilates_remote_data_source.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/services.dart';

/// Programs: `GET /api/v1/pilates/programs` — the backend's Programs tab is
/// the exact same `Category → Workout → Exercise` shape as Discover (see
/// `apis/readme-cLqG (2).md`), so this loads straight into [CategoryModel]/
/// [WorkoutModel] with **no adapter** — network → local cache →
/// bundled-JSON fallback, same chain as [DiscoverRepository]. Never throws
/// for "the network is down".
///
/// The Phases program (see `PhasesScreen`/`ProgramsProgress`) treats every
/// category returned here as one **phase** and every workout inside it as
/// one **day** — `assets/json/programs.json` is authored in this exact flat
/// shape (matching the live API's content-authoring format) rather than a
/// separate nested one, so a phase is just "the next category in the list."
class WorkoutRepository {
  static List<CategoryModel>? _cached;
  static PilatesRemoteDataSource? _remote;

  static PilatesRemoteDataSource get _dataSource =>
      _remote ??= PilatesRemoteDataSource();

  static Future<List<CategoryModel>> loadPrograms({bool forceRefresh = false}) async {
    if (_cached != null && !forceRefresh) return _cached!;

    try {
      final cachedEtag = storage.getString(PrefsKeys.programsEtag);
      final response = await _dataSource.fetchPrograms(
        etag: forceRefresh || cachedEtag.isEmpty ? null : cachedEtag,
      );

      if (response.notModified) {
        final cached = _readCache();
        if (cached != null) {
          _cached = cached;
          return cached;
        }
        // Server thinks we have a copy but the local cache was cleared —
        // fetch clean instead of returning nothing.
        return await _onFetched(await _dataSource.fetchPrograms());
      }

      return await _onFetched(response);
    } on ApiException catch (error) {
      developer.log('Falling back after API error: $error', name: 'WorkoutRepository');
      return _fallback();
    } catch (error) {
      developer.log('Falling back after unexpected error: $error', name: 'WorkoutRepository');
      return _fallback();
    }
  }

  static Future<List<CategoryModel>> _onFetched(
    PilatesCategoriesResponse response,
  ) async {
    _cached = response.categories;
    await _writeCache(response.categories, response.etag);
    return response.categories;
  }

  /// Local cache first (closest to what the user last actually saw), then
  /// the bundled catalogue.
  static Future<List<CategoryModel>> _fallback() async {
    final cached = _readCache();
    if (cached != null && cached.isNotEmpty) {
      _cached = cached;
      return cached;
    }

    final bundled = await _loadBundledAsset();
    _cached = bundled;
    return bundled;
  }

  static List<CategoryModel>? _readCache() {
    final String raw;
    try {
      raw = storage.getString(PrefsKeys.programsCache);
    } catch (error) {
      // Storage not initialized yet (or otherwise unavailable) — treat it
      // the same as an absent cache rather than letting the fallback chain
      // itself fail.
      developer.log(
        'Storage unavailable, skipping cache read: $error',
        name: 'WorkoutRepository',
      );
      return null;
    }
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
      developer.log('Ignoring corrupt programs cache: $error', name: 'WorkoutRepository');
      return null;
    }
  }

  static Future<void> _writeCache(
    List<CategoryModel> categories,
    String? etag,
  ) async {
    if (categories.isEmpty) return;
    try {
      await storage.setString(
        PrefsKeys.programsCache,
        jsonEncode(categories.map((c) => c.toJson()).toList()),
      );
      if (etag != null && etag.isNotEmpty) {
        await storage.setString(PrefsKeys.programsEtag, etag);
      }
    } catch (error) {
      // Caching is a best-effort convenience — never let a write failure
      // bubble up and fail the actual load.
      developer.log('Failed to persist programs cache: $error', name: 'WorkoutRepository');
    }
  }

  static Future<List<CategoryModel>> _loadBundledAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/programs.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
