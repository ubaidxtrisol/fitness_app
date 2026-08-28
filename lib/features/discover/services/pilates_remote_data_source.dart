import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/core/network/api_endpoints.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';

/// One `GET /api/v1/pilates/categories` call, decoded — or `notModified`
/// when the server confirmed the caller's `ETag` is still current.
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

/// Raw calls against the Pilates endpoints in `readme-v3Nm.md` — decodes
/// responses into the shared discover models and throws [ApiException] on
/// any failure. Callers (see [DiscoverRepository]) own the cache/fallback
/// decisions; this class only knows how to talk to the API.
class PilatesRemoteDataSource {
  PilatesRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  /// Full discover catalogue. Root is a JSON array (not wrapped) per the API
  /// contract. Passing [etag] sends `If-None-Match`; a `304` comes back as
  /// [PilatesCategoriesResponse.notModified] rather than throwing.
  Future<PilatesCategoriesResponse> fetchCategories({String? etag}) async {
    final response = await _client.get<dynamic>(
      ApiEndpoints.pilatesCategories,
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
