import 'dart:convert';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:flutter/services.dart';

/// Mirrors [DiscoverRepository] — bundled JSON now, swappable for the API later.
class WorkoutRepository {
  static List<ProgramModel>? _cachedPrograms;

  static Future<List<ProgramModel>> loadPrograms() async {
    if (_cachedPrograms != null) return _cachedPrograms!;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/programs.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is List) {
        _cachedPrograms = decoded
            .map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return _cachedPrograms!;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
