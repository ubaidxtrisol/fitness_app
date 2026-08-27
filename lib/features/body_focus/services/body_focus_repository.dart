import 'dart:convert';
import 'package:fitness_app/features/body_focus/models/body_focus_model.dart';
import 'package:flutter/services.dart';

/// Mirrors the other repositories; days reference a shared exercise catalogue
/// so the bundled JSON stays small.
class BodyFocusRepository {
  static List<BodyFocusCategoryModel>? _cached;

  static Future<List<BodyFocusCategoryModel>> loadCategories() async {
    if (_cached != null) return _cached!;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/body_focus.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return [];

      final catalogue =
          (decoded['exercises'] as Map<String, dynamic>?) ?? const {};
      final categories = (decoded['categories'] as List<dynamic>?) ?? const [];

      _cached = categories
          .whereType<Map<String, dynamic>>()
          .map((c) => BodyFocusCategoryModel.fromJson(_resolve(c, catalogue)))
          .toList();
      return _cached!;
    } catch (e) {
      return [];
    }
  }

  /// Finds the category behind a Home tile id, falling back to a title match.
  static Future<BodyFocusCategoryModel?> findCategory({
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

  static Map<String, dynamic> _resolve(
    Map<String, dynamic> category,
    Map<String, dynamic> catalogue,
  ) {
    final workouts = (category['workouts'] as List<dynamic>?) ?? const [];

    for (final workout in workouts.whereType<Map<String, dynamic>>()) {
      final sessions = (workout['sessions'] as List<dynamic>?) ?? const [];

      for (final session in sessions.whereType<Map<String, dynamic>>()) {
        final ids = (session['exercise_ids'] as List<dynamic>?) ?? const [];
        session['exercises'] = ids
            .map((id) => catalogue[id])
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }

    return category;
  }
}
