import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthStatus extends ChangeNotifier {
  bool get isAuthenticated;
}

class SupabaseAuthStatus extends AuthStatus {
  SupabaseAuthStatus(SupabaseClient client)
      : _isAuthenticated = client.auth.currentSession != null {
    _subscription = client.auth.onAuthStateChange.listen((authState) {
      final isAuthenticated = authState.session != null;
      if (isAuthenticated != _isAuthenticated) {
        _isAuthenticated = isAuthenticated;
        notifyListeners();
      }
    });
  }

  bool _isAuthenticated;
  late final StreamSubscription<AuthState> _subscription;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

final authStatusProvider = Provider<AuthStatus>((ref) {
  final status = SupabaseAuthStatus(Supabase.instance.client);
  ref.onDispose(status.dispose);
  return status;
});
