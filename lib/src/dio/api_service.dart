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

  /// Sends a GET request to the given [path].
  ///
  /// [query] represents optional query parameters.
  ///
  /// Returns a [Response] containing the parsed response body.
  ///
  /// Example:
  /// ```dart
  /// await apiService.get(
  ///   path: '/users',
  ///   query: {'page': 1},
  /// );
  /// ```
  Future<Response<T>> get<T>({
    required String path,
    Map<String, dynamic>? query,
    Object? data,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    Options? options,
  }) {
    return dio.get<T>(
      path,
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
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
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
  }) {
    return dio.put<T>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: options,
      queryParameters: query,
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
  }) {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: query,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
