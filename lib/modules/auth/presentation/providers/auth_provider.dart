import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/auth/domain/domain.dart';
import 'package:teslo_shop/modules/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final User? user;
  final AuthStatus authStatus;
  final String? errorMessage;

  AuthState({
    this.user,
    this.authStatus = AuthStatus.checking,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    AuthStatus? authStatus,
    String? errorMessage,
  }) => AuthState(
    user: user ?? this.user,
    authStatus: authStatus ?? this.authStatus,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

class AuthNotifier extends Notifier<AuthState> {
  final AuthRepository authRepository;
  final BaseLocalStorageService localStorage;

  AuthNotifier({required this.authRepository, required this.localStorage});

  @override
  AuthState build() => AuthState();

  Future<void> startLogin(String email, String password) async {
    await Future.delayed(const Duration(microseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      await _setAutenticatedUser(user);
    } on AuthError catch (e) {
      startLogout(e.message);
    } catch (e) {
      startLogout('Unhandled error.');
    }
  }

  Future<void> startLogout([String? errorMessage]) async {
    await localStorage.removeItem('token');

    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );
  }

  Future<void> startCheckAuthStatus(String token) async {}

  Future<void> _setAutenticatedUser(User user) async {
    await localStorage.setItem('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: null,
    );
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier(
    authRepository: ApiAuthRepository(),
    localStorage: SharedPreferencesService(),
  );
});
