import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/product/domain/datasources/datasources.dart';
import 'package:teslo_shop/modules/product/domain/entities/entities.dart';
import 'package:teslo_shop/modules/product/infrastructure/errors/errors.dart';
import 'package:teslo_shop/modules/product/infrastructure/mappers/mappers.dart';
import 'package:teslo_shop/modules/shared/infrastructure/infrastructure.dart';

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
    } catch (e) {
      handleDioError(e, ProductError.new);
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _dio.get('/products/$id');

      final product = ProductMapper.apiJsonProductToEntity(response.data);

      return product;
    } catch (e) {
      handleDioError(
        e,
        ProductError.new,
        statusMessages: {404: 'Product not found.'},
      );
    }
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) async {
    try {
      final response = await _dio.post('/products', data: productLike);

      final product = ProductMapper.apiJsonProductToEntity(response.data);

      return product;
    } catch (e) {
      handleDioError(
        e,
        ProductError.new,
        statusMessages: {400: 'Invalid product data.'},
      );
    }
  }

  @override
  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> productLike,
  ) async {
    try {
      final response = await _dio.patch(
        '/products/$productId',
        data: productLike,
      );

      final product = ProductMapper.apiJsonProductToEntity(response.data);

      return product;
    } catch (e) {
      handleDioError(
        e,
        ProductError.new,
        statusMessages: {400: 'Invalid product data.'},
      );
    }
  }
}
