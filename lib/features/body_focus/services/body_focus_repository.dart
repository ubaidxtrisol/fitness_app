import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/core/network/pilates_remote_data_source.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/services.dart';

/// Body Focus: `GET /api/v1/pilates/body-focus` — the same
/// `Category → Workout → Exercise` shape as Discover/Programs (see
/// `apis/readme-cLqG (2).md`), so this loads straight into [CategoryModel]/
/// [WorkoutModel] with **no adapter** — network → local cache →
/// bundled-JSON fallback, same chain as [DiscoverRepository]. Never throws
/// for "the network is down".
///
/// The bundled `assets/json/body_focus.json` still ships an extra
/// `sessions` layer per workout (each session's `exercise_ids` resolved
/// against a shared exercise catalogue); only the *bundled-asset* fallback
/// tier flattens every session's exercises into one `workout.exercises`
/// list, in session order — the shape the (now session-less) UI expects.
///
/// Note: live category ids (e.g. `cat_flexibility_01`) don't match the four
/// ids the Home screen's tiles are hardcoded to (`butt_leg`/`abs`/
/// `full_body`/`arm` — see `apis/API_REQUIREMENTS.md` §4.4); [findCategory]'s
/// id/title-then-first fallback is what actually resolves a tile until the
/// backend seeds those exact ids.
class BodyFocusRepository {
  static List<CategoryModel>? _cached;
  static PilatesRemoteDataSource? _remote;

  static PilatesRemoteDataSource get _dataSource =>
      _remote ??= PilatesRemoteDataSource();

  static Future<List<CategoryModel>> loadCategories({
    bool forceRefresh = false,
  }) async {
    if (_cached != null && !forceRefresh) return _cached!;

    try {
      final cachedEtag = storage.getString(PrefsKeys.bodyFocusEtag);
      final response = await _dataSource.fetchBodyFocus(
        etag: forceRefresh || cachedEtag.isEmpty ? null : cachedEtag,
      );

      if (response.notModified) {
        final cached = _readCache();
        if (cached != null) {
          _cached = cached;
          return cached;
        }
        return await _onFetched(await _dataSource.fetchBodyFocus());
      }

      return await _onFetched(response);
    } on ApiException catch (error) {
      developer.log(
        'Falling back after API error: $error',
        name: 'BodyFocusRepository',
      );
      return _fallback();
    } catch (error) {
      developer.log(
        'Falling back after unexpected error: $error',
        name: 'BodyFocusRepository',
      );
      return _fallback();
    }
  }

  /// Finds the category behind a Home tile id, falling back to a title match.
  static Future<CategoryModel?> findCategory({
    required String id,
    required String title,
  }) async {
    final categories = await loadCategories();
    if (categories.isEmpty) return null;

    for (final category in categories) {
      if (category.id == id) return category;
    }
    for (final category in categories) {
      if (category.title.toLowerCase() == title.toLowerCase()) return category;
    }
    return categories.first;
  }

  static Future<List<CategoryModel>> _onFetched(
    PilatesCategoriesResponse response,
  ) async {
    _cached = response.categories;
    await _writeCache(response.categories, response.etag);
    return response.categories;
  }

  /// Local cache first, then the bundled catalogue.
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
      raw = storage.getString(PrefsKeys.bodyFocusCache);
    } catch (error) {
      developer.log(
        'Storage unavailable, skipping cache read: $error',
        name: 'BodyFocusRepository',
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
      developer.log(
        'Ignoring corrupt body focus cache: $error',
        name: 'BodyFocusRepository',
      );
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
        PrefsKeys.bodyFocusCache,
        jsonEncode(categories.map((c) => c.toJson()).toList()),
      );
      if (etag != null && etag.isNotEmpty) {
        await storage.setString(PrefsKeys.bodyFocusEtag, etag);
      }
    } catch (error) {
      developer.log(
        'Failed to persist body focus cache: $error',
        name: 'BodyFocusRepository',
      );
    }
  }

  static Future<List<CategoryModel>> _loadBundledAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/body_focus.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return [];

      final catalogue =
          (decoded['exercises'] as Map<String, dynamic>?) ?? const {};
      final categories = (decoded['categories'] as List<dynamic>?) ?? const [];

      return categories
          .whereType<Map<String, dynamic>>()
          .map((c) => _flattenCategory(c, catalogue))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static CategoryModel _flattenCategory(
    Map<String, dynamic> category,
    Map<String, dynamic> catalogue,
  ) {
    final rawWorkouts = (category['workouts'] as List<dynamic>?) ?? const [];

    final workouts = rawWorkouts.whereType<Map<String, dynamic>>().map((workout) {
      final sessions = (workout['sessions'] as List<dynamic>?) ?? const [];
      final exercises = <Map<String, dynamic>>[];
      for (final session in sessions.whereType<Map<String, dynamic>>()) {
        final ids = (session['exercise_ids'] as List<dynamic>?) ?? const [];
        exercises.addAll(
          ids.map((id) => catalogue[id]).whereType<Map<String, dynamic>>(),
        );
      }
      return WorkoutModel.fromJson({...workout, 'exercises': exercises});
    }).toList();

    return CategoryModel(
      id: category['id'] as String? ?? '',
      title: category['title'] as String? ?? '',
      description: '',
      workouts: workouts,
    );
  }
}
