import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/auth/auth.dart';

class AppRouterNotifier extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.checking;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

  AuthStatus get authStatus => _authStatus;
}

final appRouterNotifierProvider = Provider<AppRouterNotifier>((ref) {
  final notifier = AppRouterNotifier();

  ref.listen<AuthState>(authNotifierProvider, (previous, next) {
    final prevAuthStatus = previous?.authStatus;
    final nextAuthStatus = next.authStatus;

    if (prevAuthStatus == nextAuthStatus) return;

    notifier.authStatus = nextAuthStatus;
  });

  return notifier;
});
