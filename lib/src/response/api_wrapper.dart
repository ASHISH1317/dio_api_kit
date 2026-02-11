import '../config/api_config.dart';
import 'api_response.dart';

/// A centralized utility for handling API calls.
///
/// [APIWrapper] provides a consistent way to:
/// - Validate API response success
/// - Extract typed data
/// - Handle errors
/// - Avoid repetitive boilerplate across repositories
///
/// Before using [handleApiCall], the wrapper must be
/// initialized using [initialize].
///
/// Example:
/// ```dart
/// APIWrapper.initialize(
///   ApiConfig(
///     isSuccess: (status) => status == true || status == 200,
///   ),
/// );
/// ```
class APIWrapper {
  static ApiConfig? _config;

  /// Initializes the API wrapper with the given [ApiConfig].
  ///
  /// This must be called once (typically during app startup)
  /// before making any API calls through [handleApiCall].
  ///
  /// Throws if not initialized before usage.
  static void initialize(ApiConfig config) {
    _config = config;
  }

  /// Internal helper to determine whether a response
  /// should be treated as successful.
  ///
  /// Delegates success evaluation to the configured
  /// [ApiConfig.isSuccess] resolver.
  ///
  /// Throws an [Exception] if the wrapper was not initialized.
  static bool _isSuccess(dynamic status) {
    if (_config == null) {
      throw Exception('APIWrapper not initialized');
    }
    return _config!.isSuccess(status);
  }

  /// Executes an API request and handles response validation.
  ///
  /// This method:
  /// - Awaits the provided [request]
  /// - Evaluates success using the configured resolver
  /// - Returns parsed data if successful
  /// - Triggers [onError] callback if failed
  ///
  /// Parameters:
  /// - [request]: A function that returns a `Future<ApiResponse<T>>`
  /// - [onError]: Optional callback for handling error messages
  ///
  /// Returns:
  /// - Parsed data of type [T] if successful
  /// - `null` if the response is not successful
  ///
  /// Example:
  /// ```dart
  /// final user = await APIWrapper.handleApiCall<User>(
  ///   request: () async {
  ///     final response = await apiService.get<Map<String, dynamic>>(
  ///       path: '/user',
  ///     );
  ///
  ///     return ApiResponse<User>.fromJson(
  ///       response.data!,
  ///       statusExtractor: (json) => json['status'],
  ///       messageExtractor: (json) => json['message'],
  ///       dataParser: (data) => User.fromJson(data),
  ///     );
  ///   },
  ///   onError: (message) => print(message),
  /// );
  /// ```
  ///
  /// Throws:
  /// - Rethrows any unexpected exceptions after calling [onError].
  static Future<T?> handleApiCall<T>({
    required Future<ApiResponse<T>> Function() request,
    void Function(String message)? onError,
  }) async {
    try {
      final ApiResponse<T> response = await request();

      if (_isSuccess(response.status)) {
        return response.data;
      }

      onError?.call(response.message ?? 'Something went wrong');
      return null;
    } catch (e) {
      onError?.call('Something went wrong');
      rethrow;
    }
  }
}
