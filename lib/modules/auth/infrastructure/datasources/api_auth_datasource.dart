import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/auth/domain/domain.dart';
import 'package:teslo_shop/modules/auth/infrastructure/errors/errors.dart';
import 'package:teslo_shop/modules/auth/infrastructure/mappers/mappers.dart';

class ApiAuthDatasource extends AuthDatasource {
  final Dio _dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    throw UnimplementedError();
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
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw AuthError('Invalid credentials.');
      }

      if (error.type == DioExceptionType.connectionTimeout) {
        throw AuthError('Network error.');
      }

      throw AuthError('Something went wrong. Please, try again.');
    } catch (e) {
      throw AuthError('Unknown error.');
    }
  }

  @override
  Future<User> register(String fullName, String email, String password) {
    throw UnimplementedError();
  }
}
