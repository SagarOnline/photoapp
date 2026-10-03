import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_status_provider.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/hives/screens/hives_screen.dart';
import '../../services/api_client.dart';
import '../../services/api_client_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authStatus,
    redirect: (context, state) {
      final isSignInRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation.startsWith('/sign-in/');
      if (!authStatus.isAuthenticated && !isSignInRoute) {
        return '/sign-in';
      }
      if (authStatus.isAuthenticated && isSignInRoute) {
        return '/';
      }
      if (authStatus.isAuthenticated && state.matchedLocation == '/') {
        return ref
            .read(apiClientProvider)
            .get('me')
            .then((profile) {
              return profile['registered'] == true ? null : '/sign-up';
            })
            .catchError((Object error) {
              if (error is ApiException && error.statusCode == 401) {
                return '/sign-in';
              }
              return '/sign-up';
            });
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'hives',
        builder: (context, state) => const HivesScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-in/email',
        name: 'sign-in-email',
        builder: (context, state) => const EmailSignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
