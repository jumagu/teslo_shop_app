import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/auth/domain/domain.dart';
import 'package:teslo_shop/modules/auth/infrastructure/errors/errors.dart';
import 'package:teslo_shop/modules/auth/infrastructure/mappers/mappers.dart';
import 'package:teslo_shop/modules/shared/infrastructure/infrastructure.dart';

class ApiAuthDatasource extends AuthDatasource {
  final Dio _dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await _dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final user = UserMapper.apiJsonUserToEntity(response.data);

      return user;
    } catch (e) {
      handleDioError(
        e,
        AuthError.new,
        statusMessages: {401: 'Your session has expired. Please log in again.'},
      );
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final user = UserMapper.apiJsonUserToEntity(response.data);

      return user;
    } catch (e) {
      handleDioError(
        e,
        AuthError.new,
        statusMessages: {401: 'Invalid credentials.'},
      );
    }
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    throw UnimplementedError();
  }
}
