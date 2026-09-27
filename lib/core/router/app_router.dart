import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_status_provider.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/hives/screens/hives_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authStatus,
    redirect: (context, state) {
      final isSignInRoute = state.matchedLocation == '/sign-in';
      if (!authStatus.isAuthenticated && !isSignInRoute) {
        return '/sign-in';
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
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
