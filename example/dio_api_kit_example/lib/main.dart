import 'dart:developer';
import 'package:dio_api_kit/dio_api_kit.dart';
import 'package:flutter/material.dart';

/// Entry point of the application.
///
/// Initializes [DioApiKit] with:
/// - Base URL
/// - Success status validator
/// - Optional interceptors (e.g., logging)
void main() {
  DioApiKit.initialize(
    baseUrl: 'https://dummyjson.com',

    /// Defines which HTTP status codes are considered successful.
    apiConfig: ApiConfig(isSuccess: (status) => status == 200),

    /// Optional Dio interceptors.
    /// Here we log full response bodies for debugging purposes.
    interceptors: [LogInterceptor(responseBody: true)],
  );

  runApp(const MyApp());
}

/// Root widget of the example application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExampleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Example screen demonstrating:
/// - API request using dio_api_kit
/// - Loading state handling
/// - Error handling
/// - Rendering fetched data in a ListView
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  /// Indicates whether API request is in progress.
  bool _loading = false;

  /// Stores error message (if any).
  String? _error;

  /// List of posts fetched from API.
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();

    /// Automatically fetch posts when screen loads.
    _loadPosts();
  }

  /// Fetches posts from `/posts` endpoint.
  ///
  /// Uses [APIWrapper.handleApiCall] to:
  /// - Safely execute API request
  /// - Handle errors gracefully
  /// - Return parsed data if successful
  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await APIWrapper.handleApiCall<List<Map<String, dynamic>>>(
      request: () async {
        /// Perform GET request
        final response = await DioApiKit.api.get<Map<String, dynamic>>(
          path: '/posts',
        );

        /// Construct ApiResponse manually because
        /// dummyjson wraps posts inside `posts` key.
        return ApiResponse<List<Map<String, dynamic>>>(
          status: response.statusCode ?? 0,
          data: (response.data?['posts'] as List).cast<Map<String, dynamic>>(),
          message: null,
        );
      },

      /// Error callback
      onError: (e) {
        log('API Error: $e');

        setState(() {
          _error = e.toString();
        });
      },
    );

    /// If request successful, update UI with first 5 posts.
    if (result != null) {
      setState(() {
        _posts = result.take(5).toList();
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dio_api_kit Example'),
        centerTitle: true,
      ),

      /// Manual refresh button
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPosts,
        child: const Icon(Icons.refresh),
      ),

      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
            ? Text('Error: $_error', textAlign: TextAlign.center)
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];

                  return ListTile(
                    title: Text(post['title'] ?? ''),
                    subtitle: Text(post['body'] ?? ''),
                  );
                },
              ),
      ),
    );
  }
}
