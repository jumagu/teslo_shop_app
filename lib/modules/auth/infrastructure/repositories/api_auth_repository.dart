import 'package:teslo_shop/modules/auth/domain/domain.dart';
import 'package:teslo_shop/modules/auth/infrastructure/datasources/datasources.dart';

class ApiAuthRepository extends AuthRepository {
  final AuthDatasource authDatasource;

  ApiAuthRepository({AuthDatasource? authDatasource})
    : authDatasource = authDatasource ?? ApiAuthDatasource();

  @override
  Future<User> checkAuthStatus(String token) {
    return authDatasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    return authDatasource.register(fullName, email, password);
  }
}
