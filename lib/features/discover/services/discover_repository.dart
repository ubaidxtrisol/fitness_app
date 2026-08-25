import 'dart:convert';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/services.dart';

class DiscoverRepository {
  static List<CategoryModel>? _cachedCategories;

  static Future<List<CategoryModel>> loadCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;

    try {
      final jsonString = await rootBundle.loadString('assets/json/pilates.json');
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        _cachedCategories = decoded
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return _cachedCategories!;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
