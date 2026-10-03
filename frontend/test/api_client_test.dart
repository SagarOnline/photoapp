import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:photoapp/services/api_client.dart';

void main() {
  test('sends the current bearer token and JSON body', () async {
    http.Request? capturedRequest;
    final client = ApiClient(
      baseUri: Uri.parse('https://api.example.test/api/v1/'),
      getAccessToken: () async => 'access-token',
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode({'id': 'hive-id'}), 201);
      }),
    );

    final response = await client.post('hives', body: {'name': 'Trip'});

    expect(response['id'], 'hive-id');
    expect(capturedRequest?.url.path, '/api/v1/hives');
    expect(capturedRequest?.headers['authorization'], 'Bearer access-token');
    expect(jsonDecode(capturedRequest!.body), {'name': 'Trip'});
  });

  test('does not send a request without an authenticated session', () async {
    var requestSent = false;
    final client = ApiClient(
      baseUri: Uri.parse('https://api.example.test/api/v1/'),
      getAccessToken: () async => null,
      httpClient: MockClient((_) async {
        requestSent = true;
        return http.Response('{}', 200);
      }),
    );

    await expectLater(
      client.get('hives'),
      throwsA(
        isA<ApiException>().having((error) => error.statusCode, 'status', 401),
      ),
    );
    expect(requestSent, isFalse);
  });

  test('maps API error envelopes to ApiException', () async {
    final client = ApiClient(
      baseUri: Uri.parse('https://api.example.test/api/v1/'),
      getAccessToken: () async => 'access-token',
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'statusCode': 403,
            'code': 'PROFILE_INCOMPLETE',
            'message': 'Complete your profile first.',
          }),
          403,
        ),
      ),
    );

    await expectLater(
      client.get('hives'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'PROFILE_INCOMPLETE',
        ),
      ),
    );
  });

  test('does not forward the bearer token to the signed storage URL', () async {
    http.Request? capturedRequest;
    final client = ApiClient(
      baseUri: Uri.parse('https://api.example.test/api/v1/'),
      getAccessToken: () async => 'access-token',
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response('', 200);
      }),
    );

    await client.uploadAuthorizedBytes(
      uploadUri: Uri.parse('https://storage.example.test/signed-object'),
      bytes: [1, 2, 3],
      contentType: 'image/jpeg',
    );

    expect(capturedRequest?.headers.containsKey('authorization'), isFalse);
    expect(capturedRequest?.headers['content-type'], 'image/jpeg');
    expect(capturedRequest?.bodyBytes, [1, 2, 3]);
  });
}
