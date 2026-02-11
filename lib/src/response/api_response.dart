/// A generic API response model.
///
/// [ApiResponse] is designed to be backend-agnostic and flexible.
/// It does not assume any fixed response structure.
///
/// Instead, it relies on extractor and parser callbacks to map
/// raw JSON responses into a strongly typed model.
///
/// This allows support for APIs that return:
/// - `status` as `bool`, `int`, or `String`
/// - `data` nested under different keys
/// - Optional or missing message fields
///
/// Example:
/// ```dart
/// final response = ApiResponse<User>.fromJson(
///   json,
///   statusExtractor: (json) => json['status'],
///   messageExtractor: (json) => json['message'],
///   dataParser: (data) => User.fromJson(data),
/// );
/// ```
class ApiResponse<T> {
  /// Raw status value returned by the backend.
  ///
  /// This value is intentionally kept as `dynamic`
  /// to support different API conventions such as:
  /// - `true / false`
  /// - HTTP status codes (`200`, `201`)
  /// - String values (`"ok"`, `"success"`)
  final dynamic status;

  /// Optional message returned by the backend.
  ///
  /// Typically used for:
  /// - Error messages
  /// - Informational messages
  /// - User-facing feedback
  final String? message;

  /// Parsed response data.
  ///
  /// The type [T] is defined by the caller and is
  /// parsed using the provided `dataParser` callback.
  final T? data;

  /// Creates an [ApiResponse] instance.
  ///
  /// This constructor is rarely used directly.
  /// Prefer using [ApiResponse.fromJson] for API responses.
  const ApiResponse({this.status, this.message, this.data});

  /// Creates an [ApiResponse] from a raw JSON map.
  ///
  /// This factory requires explicit extractors to avoid
  /// coupling the response model to any specific backend format.
  ///
  /// Parameters:
  /// - [statusExtractor]: Extracts the status value from the JSON.
  /// - [dataParser]: Converts the raw data payload into type [T].
  /// - [messageExtractor]: (Optional) Extracts a message from the JSON.
  ///
  /// This design enables flexible parsing for APIs with
  /// inconsistent or non-standard response structures.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required dynamic Function(Map<String, dynamic>) statusExtractor,
    required T Function(dynamic json) dataParser,
    String Function(Map<String, dynamic>)? messageExtractor,
  }) {
    return ApiResponse<T>(
      status: statusExtractor(json),
      message: messageExtractor?.call(json),
      data: dataParser(json['data']),
    );
  }
}
