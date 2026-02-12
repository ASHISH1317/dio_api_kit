import 'package:dio/dio.dart';

/// A lightweight wrapper around [Dio] that exposes
/// standard HTTP methods in a clean and reusable way.
///
/// [APIService] does not contain any business logic.
/// It is responsible only for making raw HTTP requests.
///
/// This keeps networking concerns separated from
/// response parsing and success handling layers.
///
/// Example:
/// ```dart
/// final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
/// final apiService = APIService(dio);
///
/// final response = await apiService.get<Map<String, dynamic>>(
///   path: '/users',
/// );
/// ```
class APIService {
  /// The underlying [Dio] instance used for HTTP requests.
  ///
  /// This instance should already be configured with:
  /// - Base URL
  /// - Interceptors
  /// - Headers
  /// - Timeouts
  final Dio dio;

  /// Creates an [APIService] with a configured [Dio] instance.
  ///
  /// The [dio] instance should be initialized outside
  /// and injected for better testability and flexibility.
  APIService(this.dio);

  /// Prepares the URL for the given [path].
  /// Force base url handled
  String _prepareUrl(String path, String? forceBaseUrl) {
    if (forceBaseUrl != null && forceBaseUrl.trim().isNotEmpty) {
      final base = forceBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
      final p = path.trim().replaceAll(RegExp(r'^/+'), '');
      return '$base/$p';
    }
    return path;
  }

  /// Sends a GET request to the given [path].
  ///
  /// [query] represents optional query parameters.
  ///
  /// Returns a [Response] containing the parsed response body.
  Future<Response<T>> get<T>({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    Options? options,
    String? forceBaseUrl,
  }) {
    String url = _prepareUrl(path, forceBaseUrl);
    return dio.get<T>(
      url,
      queryParameters: query,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  /// Sends a POST request to the given [path].
  ///
  /// [data] is the request body.
  /// [query] represents optional query parameters.
  ///
  /// Typically used for:
  /// - Creating resources
  /// - Submitting forms
  /// - Authentication
  Future<Response<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    String? forceBaseUrl,
  }) {
    String url = _prepareUrl(path, forceBaseUrl);
    return dio.post<T>(
      url,
      data: data,
      queryParameters: query,
      options: options,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Sends a PUT request to the given [path].
  ///
  /// [data] is the request body.
  ///
  /// Commonly used for replacing existing resources.
  Future<Response<T>> put<T>({
    required String path,
    dynamic data,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
    Map<String, dynamic>? query,
    String? forceBaseUrl,
  }) {
    String url = _prepareUrl(path, forceBaseUrl);
    return dio.put<T>(
      url,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: options,
      queryParameters: query,
    );
  }

  /// Sends a PATCH request to the given [path].
  ///
  /// [data] contains partial fields to be updated.
  ///
  /// Commonly used for:
  /// - Partial updates
  /// - Toggling flags
  /// - Updating a subset of a resource
  ///
  /// Example:
  /// ```dart
  /// await apiService.patch(
  ///   path: '/users/1',
  ///   data: {'isActive': true},
  /// );
  /// ```
  Future<Response<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
    void Function(int, int)? onReceiveProgress,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    String? forceBaseUrl,
  }) {
    String url = _prepareUrl(path, forceBaseUrl);
    return dio.patch<T>(
      url,
      data: data,
      queryParameters: query,
      options: options,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Sends a DELETE request to the given [path].
  ///
  /// [data] can optionally contain a request body
  /// (some backends support DELETE with body payload).
  ///
  /// Used for removing resources.
  Future<Response<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    Options? options,
    String? forceBaseUrl,
  }) {
    String url = _prepareUrl(path, forceBaseUrl);
    return dio.delete<T>(
      url,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
