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
      final response = await _dio.get<List>(
        '/products?limit=$limit&offset=$offset',
      );

      if (response.data == null) return [];

      return [
        ...response.data!.map((p) => ProductMapper.apiJsonProductToEntity(p)),
      ];
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        throw ProductError('Network error.');
      }

      throw ProductError('Something went wrong. Please, try again.');
    } catch (e) {
      throw ProductError('Unknown error.');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/products/$id');

      final product = ProductMapper.apiJsonProductToEntity(response.data);

      return product;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        throw ProductError('Network error.');
      }

      if (error.response!.statusCode == 404) {
        throw ProductError('Product not found.');
      }

      throw ProductError('Something went wrong. Please, try again.');
    } catch (e) {
      throw ProductError('Unknown error.');
    }
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
