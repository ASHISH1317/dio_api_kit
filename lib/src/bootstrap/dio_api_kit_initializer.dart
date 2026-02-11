import 'dart:async';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../dio/api_service.dart';
import '../response/api_wrapper.dart';

/// Central initializer for dio_api_kit.
///
/// This class is responsible for:
/// - Creating and configuring Dio
/// - Creating APIService
/// - Initializing APIWrapper
///
/// This must be called once at app startup.
class DioApiKit {
  static late final APIService api;

  /// Initializes dio_api_kit.
  ///
  /// This method should be called before any API call.
  static void initialize({
    required String baseUrl,
    required ApiConfig apiConfig,
    List<Interceptor>? interceptors,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    String? contentType,
    Map<String, dynamic>? extra,
    bool? followRedirects,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ListFormat? listFormat,
    int? maxRedirects,
    String? method,
    bool? persistentConnection,
    bool? preserveHeaderCase,
    bool? receiveDataWhenStatusError,
    FutureOr<List<int>> Function(String, RequestOptions)? requestEncoder,
    FutureOr<String?> Function(
      List<int> bytes,
      RequestOptions options,
      ResponseBody responseBody,
    )?
    responseDecoder,
    ResponseType? responseType,
    Duration? sendTimeout,
    bool Function(int?)? validateStatus,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        contentType: contentType,
        extra: extra,
        followRedirects: followRedirects,
        headers: headers,
        queryParameters: queryParameters,
        listFormat: listFormat,
        maxRedirects: maxRedirects,
        method: method,
        persistentConnection: persistentConnection,
        preserveHeaderCase: preserveHeaderCase,
        receiveDataWhenStatusError: receiveDataWhenStatusError,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        responseType: responseType,
        sendTimeout: sendTimeout,
        validateStatus: validateStatus,
      ),
    );

    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    api = APIService(dio);

    APIWrapper.initialize(apiConfig);
  }
}
