import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  /// Creates an API failure with an HTTP status and user-facing message.
  const ApiException(this.statusCode, this.message, {this.code});

  final int statusCode;
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class ApiClient {
  /// Creates an API client using the supplied token source and HTTP transport.
  ApiClient({
    required this.baseUri,
    required this.getAccessToken,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final Uri baseUri;
  final Future<String?> Function() getAccessToken;
  final http.Client _httpClient;

  /// Releases the underlying HTTP transport.
  void close() => _httpClient.close();

  /// Sends an authenticated GET request and decodes its JSON object response.
  Future<Map<String, Object?>> get(String path) => _send('GET', path);

  /// Sends an authenticated POST request and decodes its JSON object response.
  Future<Map<String, Object?>> post(
    String path, {
    Map<String, Object?>? body,
  }) => _send('POST', path, body: body);

  /// Sends an authenticated PUT request and decodes its JSON object response.
  Future<Map<String, Object?>> put(
    String path, {
    required Map<String, Object?> body,
  }) => _send('PUT', path, body: body);

  /// Uploads compressed bytes to a short-lived storage URL without API credentials.
  Future<void> uploadAuthorizedBytes({
    required Uri uploadUri,
    required List<int> bytes,
    required String contentType,
  }) async {
    try {
      final request = http.Request('PUT', uploadUri)
        ..headers['Content-Type'] = contentType
        ..bodyBytes = bytes;
      final response = await _httpClient
          .send(request)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          response.statusCode,
          'The media upload failed. Please try again.',
          code: 'UPLOAD_FAILED',
        );
      }
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        0,
        'Could not upload media. Check your connection and try again.',
      );
    }
  }

  Future<Map<String, Object?>> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    final token = await getAccessToken();
    if (token == null) {
      throw const ApiException(
        401,
        'Please sign in to continue.',
        code: 'UNAUTHENTICATED',
      );
    }

    final request = http.Request(method, baseUri.resolve(path))
      ..headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        if (body != null) 'Content-Type': 'application/json',
      });
    if (body != null) request.body = jsonEncode(body);

    try {
      final streamed = await _httpClient
          .send(request)
          .timeout(const Duration(seconds: 20));
      final response = await http.Response.fromStream(streamed);
      final decoded = response.body.isEmpty
          ? <String, Object?>{}
          : jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException(
          502,
          'The server returned an invalid response.',
        );
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final rawMessage = decoded['message'];
        final message = rawMessage is String
            ? rawMessage
            : 'The request could not be completed.';
        final code = decoded['code'];
        throw ApiException(
          response.statusCode,
          message,
          code: code is String ? code : null,
        );
      }
      return Map<String, Object?>.from(decoded);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        0,
        'Could not reach the server. Check your connection and try again.',
      );
    }
  }
}

/// Resolves the API base URI from the Flutter build configuration.
Uri apiBaseUri() {
  const configured = String.fromEnvironment('API_BASE_URL');
  return Uri.parse(
    configured.isEmpty
        ? 'http://localhost:3000/api/v1/'
        : configured.endsWith('/')
        ? configured
        : '$configured/',
  );
}
