import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    baseUri: apiBaseUri(),
    getAccessToken: () async =>
        Supabase.instance.client.auth.currentSession?.accessToken,
  );
  ref.onDispose(client.close);
  return client;
});
