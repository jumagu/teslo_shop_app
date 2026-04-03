import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/modules/auth/auth.dart';
import 'package:teslo_shop/modules/product/product.dart';

const needAuthRoutes = ['/', '/product/:id'];

final appRouterProvider = Provider<GoRouter>((ref) {
  final appRouterNotifier = ref.read(appRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/check-status',
    routes: [
      // ? Auth Routes
      GoRoute(path: '/check-status', builder: (context, state) => CheckAuthStatusScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),

      // ? Product Routes
      GoRoute(path: '/', builder: (context, state) => ProductsScreen()),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          return ProductScreen(productId: state.pathParameters['id'] ?? 'no-id');
        },
      ),
    ],

    // ? Every time appRouterNotifierProvider notifies a change, the router refreshes
    refreshListenable: appRouterNotifier,

    // ? This execute on every refresh
    redirect: (context, state) {
      final to = state.fullPath;
      final authStatus = appRouterNotifier.authStatus;

      if (to == '/check-status') {
        return authStatus == AuthStatus.notAuthenticated
            ? '/login'
            : authStatus == AuthStatus.authenticated
            ? '/'
            : null;
      }

      if (authStatus == AuthStatus.notAuthenticated && needAuthRoutes.contains(to)) {
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated && !needAuthRoutes.contains(to)) {
        return '/';
      }

      return null;
    },
  );
});
