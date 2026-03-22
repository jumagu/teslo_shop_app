import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/product/domain/datasources/datasources.dart';
import 'package:teslo_shop/modules/product/domain/entities/entities.dart';
import 'package:teslo_shop/modules/product/infrastructure/errors/errors.dart';
import 'package:teslo_shop/modules/product/infrastructure/mappers/mappers.dart';

class ApiProductsDatasource extends ProductsDatasource {
  late final Dio _dio;
  final String accessToken;

  ApiProductsDatasource({required this.accessToken})
    : _dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<List<Product>> getProductsPaginated({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get<List<Map<String, dynamic>>>(
        '/products?limit=$limit&offset=$offset',
      );

      final products =
          response.data?.map(ProductMapper.apiJsonProductToEntity).toList() ??
          [];

      return products;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        throw ProductError('Network error.');
      }

      throw ProductError('Something went wrong. Please, try again.');
    } catch (e) {
      throw ProductError('');
    }
  }

  @override
  Future<Product> getProductById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    throw UnimplementedError();
  }

  @override
  Future<Product> updateProduct(Map<String, dynamic> productLike) {
    throw UnimplementedError();
  }
}
