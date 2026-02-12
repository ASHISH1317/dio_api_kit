# dio_api_kit

A lightweight, flexible, and backend-agnostic API layer built on top of Dio.

`dio_api_kit` provides:
- Centralized Dio initialization
- Clean API service abstraction
- Generic API response model
- Configurable success resolver
- Unified API error handling
- Backend-independent parsing

---

## ✨ Why dio_api_kit?

Most APIs return responses in different formats:

- `status: true`
- `status: 200`
- `status: "success"`
- `success: 1`

Instead of hardcoding response assumptions, `dio_api_kit` allows you to define how success is determined — making it completely backend-agnostic.

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  dio_api_kit: ^1.*.*
```

---

## 🚀 Getting Started

1️⃣ Initialize at App Startup

Call this once (e.g., in main()):

```dart
DioApiKit.initialize(
  baseUrl: "https://api.example.com",
  apiConfig: ApiConfig(
    isSuccess: (status) => status == true || status == 200,
  ),
  interceptors: [
    LogInterceptor(responseBody: true),
  ],
);
```

---

2️⃣ Make an API Call

Example repository usage:

```dart
final user = await APIWrapper.handleApiCall<User>(
  request: () async {
    final response = await DioApiKit.api.get<Map<String, dynamic>>(
      path: '/user',
    );

    return ApiResponse<User>.fromJson(
      response.data!,
      statusExtractor: (json) => json['status'],
      messageExtractor: (json) => json['message'],
      dataParser: (data) => User.fromJson(data),
    );
  },
  onError: (message) {
    print(message);
  },
);
```

---

## 🏗 Architecture Overview

1️⃣ DioApiKit

- Initializes Dio
- Injects interceptors
- Sets base options
- Initializes APIWrapper

---

2️⃣ APIService

Thin wrapper around Dio.

Provides:
- get
- post
- put
- delete
- patch

No business logic included.

---

3️⃣ ApiResponse<T>

Generic, backend-agnostic response model.

You provide:
- statusExtractor
- messageExtractor
- dataParser

This avoids coupling to any backend format.

---

4️⃣ APIWrapper

Handles:
- Success validation
- Error propagation
- Typed data return
- Boilerplate removal

---

🎯 Design Goals

- Backend-agnostic
- Strongly typed
- Testable
- Clean architecture friendly
- Minimal boilerplate
- Easily extendable

---

🧩 Example Success Resolver

```dart
ApiConfig(
  isSuccess: (status) {
    if (status is bool) return status;
    if (status is int) return status >= 200 && status < 300;
    if (status is String) return status.toLowerCase() == "success";
    return false;
  },
);
```

---

🔐 Interceptors Support

You can inject any Dio interceptors:

```dart
interceptors: [
  LogInterceptor(),
  YourAuthInterceptor(),
]
```

---

🧪 Testing

Because APIService is injected, you can easily:
- Mock Dio
- Mock ApiResponse
- Test repositories independently

---

📄 License

MIT License

```roomsql

---

# 📜 MIT License (LICENSE file)

Create a file named `LICENSE` in your root:

```txt
MIT License

Copyright (c) 2026 ASHISH1317

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
