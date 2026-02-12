## 1.0.3

- Added support of ```force base url```

## 1.0.2

- Added ```patch``` request support.

## 1.0.1

- Example added

## 1.0.0

🎉 Initial release of `dio_api_kit`.

### Features

- Centralized Dio initialization via `DioApiKit`
- Lightweight `APIService` wrapper for HTTP methods (GET, POST, PUT, DELETE)
- Backend-agnostic `ApiResponse<T>` with customizable extractors
- Configurable success resolver using `ApiConfig`
- Unified API execution and error handling with `APIWrapper`
- Interceptor, timeout, and Dio `BaseOptions` support
- Clean separation of networking, parsing, and business logic

### Notes

- Designed to work with any backend response structure
- Focused on flexibility, testability, and minimal boilerplate
