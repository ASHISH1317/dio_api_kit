import 'package:flutter/material.dart';
import 'package:dio_api_kit/dio_api_kit.dart';

void main() {
  DioApiKit.initialize(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    apiConfig: ApiConfig(isSuccess: (status) => status == 200),
    interceptors: [LogInterceptor(responseBody: true)],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ExampleScreen());
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('dio_api_kit Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final post = await APIWrapper.handleApiCall<Map<String, dynamic>>(
              request: () async {
                final response = await DioApiKit.api.get<Map<String, dynamic>>(
                  path: '/posts/1',
                );

                return ApiResponse<Map<String, dynamic>>.fromJson(
                  response.data!,
                  statusExtractor: (_) => 200,
                  dataParser: (data) => data,
                );
              },
              onError: print,
            );

            debugPrint(post.toString());
          },
          child: const Text('Call API'),
        ),
      ),
    );
  }
}
