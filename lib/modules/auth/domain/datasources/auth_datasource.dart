import 'package:teslo_shop/modules/auth/domain/entities/entities.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);

  Future<User> register(String fullName, String email, String password);

  Future<User> checkAuthStatus(String token);
}
