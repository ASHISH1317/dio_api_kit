/// A function that determines whether an API response
/// should be treated as successful.
///
/// This allows flexibility across different backend conventions.
/// For example, some APIs use:
/// - `true / false`
/// - HTTP status codes like `200`, `201`
/// - Strings like `'ok'`, `'success'`
///
/// Example:
/// ```dart
/// final config = ApiConfig(
///   isSuccess: (status) => status == true || status == 200,
/// );
/// ```
typedef SuccessResolver = bool Function(dynamic status);

/// Configuration class for API response handling.
///
/// [ApiConfig] defines how API responses are interpreted
/// across the application, independent of backend implementation.
///
/// Currently, it allows defining a custom [SuccessResolver]
/// to determine whether a response should be considered successful.
///
/// This makes the API layer:
/// - Backend-agnostic
/// - Easily testable
/// - Flexible for different API contracts
///
/// Example:
/// ```dart
/// final apiConfig = ApiConfig(
///   isSuccess: (status) => status == true,
/// );
/// ```
class ApiConfig {
  /// Resolver used to determine if an API response
  /// represents a successful operation.
  ///
  /// The value passed to this function is typically the
  /// `status`, `success`, or equivalent field returned
  /// by the backend.
  final SuccessResolver isSuccess;

  /// Creates an [ApiConfig] instance.
  ///
  /// The [isSuccess] callback is required and is used
  /// throughout the API layer to evaluate response success.
  const ApiConfig({
    required this.isSuccess,
  });
}
