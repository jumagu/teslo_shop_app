import 'package:go_router/go_router.dart';
import 'package:teslo_shop/modules/auth/auth.dart';
import 'package:teslo_shop/modules/product/product.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/', builder: (context, state) => ProductsScreen()),
  ],
);
