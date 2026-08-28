import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/core/network/pilates_remote_data_source.dart';
import 'package:fitness_app/core/services/shared_prefrences/storage_services.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:flutter/services.dart';

/// Challenges: `GET /api/v1/pilates/challenges` first — adapted into
/// [ChallengeProgramModel] via [ChallengeProgramModel.fromApiCategory] (see
/// that doc comment for the real shape gap: the backend has no week concept
/// yet) — falling back to the last locally-cached adapted copy, then to the
/// bundled `assets/json/challenges.json`. Mirrors [DiscoverRepository]'s
/// network → cache → bundled-asset chain, and never throws for "the network
/// is down".
///
/// The bundled document keeps one exercise catalogue and has days reference
/// it by id, the way `challenges.json` ships it; [_resolve] inlines those
/// references before the models parse. This — along with [_repaginate],
/// which re-chunks the bundled content's uniform 4x7 weeks into the real
/// week layout each challenge's `days_label` implies — only applies to the
/// *bundled-asset* fallback tier: it's a fix for known defects in that
/// specific local file (see `apis/API_REQUIREMENTS.md` §8), not something
/// live API data needs.
class ChallengeRepository {
  static List<ChallengeProgramModel>? _cached;
  static PilatesRemoteDataSource? _remote;

  static PilatesRemoteDataSource get _dataSource =>
      _remote ??= PilatesRemoteDataSource();

  static Future<List<ChallengeProgramModel>> loadChallenges({
    bool forceRefresh = false,
  }) async {
    if (_cached != null && !forceRefresh) return _cached!;

    try {
      final cachedEtag = storage.getString(PrefsKeys.challengesEtag);
      final response = await _dataSource.fetchChallenges(
        etag: forceRefresh || cachedEtag.isEmpty ? null : cachedEtag,
      );

      if (response.notModified) {
        final cached = _readCache();
        if (cached != null) {
          _cached = cached;
          return cached;
        }
        return await _onFetched(await _dataSource.fetchChallenges());
      }

      return await _onFetched(response);
    } on ApiException catch (error) {
      developer.log('Falling back after API error: $error', name: 'ChallengeRepository');
      return _fallback();
    } catch (error) {
      developer.log(
        'Falling back after unexpected error: $error',
        name: 'ChallengeRepository',
      );
      return _fallback();
    }
  }

  static Future<List<ChallengeProgramModel>> _onFetched(
    PilatesCategoriesResponse response,
  ) async {
    final challenges = response.categories
        .map(ChallengeProgramModel.fromApiCategory)
        .toList();
    _cached = challenges;
    await _writeCache(challenges, response.etag);
    return challenges;
  }

  /// Local cache first, then the bundled catalogue (with its known-defect
  /// fixes applied — see the class doc comment).
  static Future<List<ChallengeProgramModel>> _fallback() async {
    final cached = _readCache();
    if (cached != null && cached.isNotEmpty) {
      _cached = cached;
      return cached;
    }

    final bundled = await _loadBundledAsset();
    _cached = bundled;
    return bundled;
  }

  static List<ChallengeProgramModel>? _readCache() {
    final String raw;
    try {
      raw = storage.getString(PrefsKeys.challengesCache);
    } catch (error) {
      // Storage not initialized yet (or otherwise unavailable) — treat it
      // the same as an absent cache rather than letting the fallback chain
      // itself fail.
      developer.log(
        'Storage unavailable, skipping cache read: $error',
        name: 'ChallengeRepository',
      );
      return null;
    }
    if (raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ChallengeProgramModel.fromJson)
          .toList();
    } catch (error) {
      developer.log(
        'Ignoring corrupt challenges cache: $error',
        name: 'ChallengeRepository',
      );
      return null;
    }
  }

  static Future<void> _writeCache(
    List<ChallengeProgramModel> challenges,
    String? etag,
  ) async {
    if (challenges.isEmpty) return;
    try {
      await storage.setString(
        PrefsKeys.challengesCache,
        jsonEncode(challenges.map((c) => c.toJson()).toList()),
      );
      if (etag != null && etag.isNotEmpty) {
        await storage.setString(PrefsKeys.challengesEtag, etag);
      }
    } catch (error) {
      developer.log(
        'Failed to persist challenges cache: $error',
        name: 'ChallengeRepository',
      );
    }
  }

  static Future<List<ChallengeProgramModel>> _loadBundledAsset() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/json/challenges.json',
      );
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) return [];

      final catalogue =
          (decoded['exercises'] as Map<String, dynamic>?) ?? const {};
      final challenges = (decoded['challenges'] as List<dynamic>?) ?? const [];

      return challenges
          .whereType<Map<String, dynamic>>()
          .map(
            (c) => ChallengeProgramModel.fromJson(
              _repaginate(_resolve(c, catalogue)),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Replaces every day's `exercise_ids` with the catalogue entries.
  static Map<String, dynamic> _resolve(
    Map<String, dynamic> challenge,
    Map<String, dynamic> catalogue,
  ) {
    final weeks = (challenge['weeks'] as List<dynamic>?) ?? const [];

    for (final week in weeks.whereType<Map<String, dynamic>>()) {
      final days = (week['days'] as List<dynamic>?) ?? const [];

      for (final day in days.whereType<Map<String, dynamic>>()) {
        final ids = (day['exercise_ids'] as List<dynamic>?) ?? const [];
        day['exercises'] = ids
            .map((id) => catalogue[id])
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }

    return challenge;
  }

  /// The bundled content authors every challenge with the same 4 weeks x 7
  /// days (28 days) regardless of what its `days_label` claims — "14 Days",
  /// "60 Days", "45 Days" and so on are placeholder display text that never
  /// matched the actual `weeks`/`days` shape. This re-chunks the days
  /// actually authored into the real week layout a challenge of that length
  /// should have: full 7-day weeks with whatever's left over in the last one
  /// (14 -> 7+7, 10 -> 7+3, 20 -> 7+7+6, ...), cycling back through the
  /// authored days when the label calls for more than were written down, so
  /// every length gets a plausible-looking week/day layout instead of every
  /// challenge silently being the same 28 days.
  static Map<String, dynamic> _repaginate(Map<String, dynamic> challenge) {
    final rawWeeks = ((challenge['weeks'] as List<dynamic>?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    if (rawWeeks.isEmpty) return challenge;

    final pool = <Map<String, dynamic>>[
      for (final week in rawWeeks)
        ...((week['days'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>(),
    ];
    if (pool.isEmpty) return challenge;

    final target =
        _parseDayCount(challenge['days_label'] as String?) ?? pool.length;

    final weeks = <Map<String, dynamic>>[];
    var cursor = 0;
    while (cursor < target) {
      final remaining = target - cursor;
      final count = remaining < 7 ? remaining : 7;
      final weekIndex = weeks.length;
      final rawWeek = rawWeeks[weekIndex % rawWeeks.length];

      weeks.add({
        'id': 'week_${weekIndex + 1}',
        'title': 'Week ${weekIndex + 1}',
        'subtitle': rawWeek['subtitle'],
        'current_day_index': 0,
        'days': List<Map<String, dynamic>>.generate(count, (i) {
          final template = pool[(cursor + i) % pool.length];
          return {...template, 'id': 'day_${i + 1}', 'title': 'Day ${i + 1}'};
        }),
      });
      cursor += count;
    }

    return {...challenge, 'weeks': weeks};
  }

  /// Pulls the leading integer out of a label like "14 Days" -> 14.
  static int? _parseDayCount(String? label) {
    if (label == null) return null;
    final match = RegExp(r'\d+').firstMatch(label);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }
}
