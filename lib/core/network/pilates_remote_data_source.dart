import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/core/network/api_endpoints.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';

/// One catalogue-list call, decoded — or `notModified` when the server
/// confirmed the caller's `ETag` is still current.
class PilatesCategoriesResponse {
  final List<CategoryModel> categories;
  final String? etag;
  final bool notModified;

  const PilatesCategoriesResponse({
    this.categories = const [],
    this.etag,
    this.notModified = false,
  });
}

/// Raw calls against every `GET /api/v1/pilates/*` catalogue-list endpoint —
/// decodes responses into the shared [CategoryModel]/[WorkoutModel]/
/// [ExerciseModel] tree and throws [ApiException] on any failure. All four
/// list endpoints (`categories`, `programs`, `challenges`, `body-focus`)
/// share the identical `Category → workouts[] → exercises[]` response shape
/// (see `apis/readme-cLqG (2).md` §"Discover catalogue") — `categories`
/// returns every section combined, the other three are pre-filtered by
/// `section_type`. Callers own the cache/fallback decisions. Programs and
/// Body Focus consume [CategoryModel]/[WorkoutModel] directly (see
/// `WorkoutRepository`/`BodyFocusRepository`); Challenges still adapts into
/// its own richer week/day model (`ChallengeProgramModel.fromApiCategory`)
/// since its bundled content — and locking/resume features — depend on
/// real week/day structure the backend doesn't return. This class only
/// knows how to talk to the API.
class PilatesRemoteDataSource {
  PilatesRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  /// All sections combined (`GET /api/v1/pilates/categories`) — the
  /// original Discover catalogue's endpoint, backward compatible.
  Future<PilatesCategoriesResponse> fetchCategories({String? etag}) =>
      _fetchSection(ApiEndpoints.pilatesCategories, etag: etag);

  /// Programs tab (`GET /api/v1/pilates/programs`, `section_type == 'program'`).
  Future<PilatesCategoriesResponse> fetchPrograms({String? etag}) =>
      _fetchSection(ApiEndpoints.pilatesPrograms, etag: etag);

  /// Challenges tab (`GET /api/v1/pilates/challenges`, `section_type == 'challenge'`).
  Future<PilatesCategoriesResponse> fetchChallenges({String? etag}) =>
      _fetchSection(ApiEndpoints.pilatesChallenges, etag: etag);

  /// Body Focus tab (`GET /api/v1/pilates/body-focus`, `section_type == 'body_focus'`).
  Future<PilatesCategoriesResponse> fetchBodyFocus({String? etag}) =>
      _fetchSection(ApiEndpoints.pilatesBodyFocus, etag: etag);

  /// Passing [etag] sends `If-None-Match`; a `304` comes back as
  /// [PilatesCategoriesResponse.notModified] rather than throwing.
  Future<PilatesCategoriesResponse> _fetchSection(
    String path, {
    String? etag,
  }) async {
    final response = await _client.get<dynamic>(
      path,
      options: Options(
        headers: {if (etag != null && etag.isNotEmpty) 'If-None-Match': etag},
        // 304 is a valid, expected outcome here — don't let Dio treat it as
        // an error and throw.
        validateStatus: (status) =>
            status != null && ((status >= 200 && status < 300) || status == 304),
      ),
    );

    if (response.statusCode == 304) {
      return const PilatesCategoriesResponse(notModified: true);
    }

    final categories = _decodeCategories(response.data);
    return PilatesCategoriesResponse(
      categories: categories,
      etag: response.headers.value('etag'),
    );
  }

  List<CategoryModel> _decodeCategories(dynamic data) {
    if (data is! List) {
      throw const DataParsingException(
        'Expected a list of categories from the server.',
      );
    }
    try {
      return data
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (_) {
      throw const DataParsingException();
    }
  }
}
