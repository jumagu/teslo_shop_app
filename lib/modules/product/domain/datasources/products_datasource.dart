import 'package:teslo_shop/modules/product/domain/entities/entities.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsPaginated({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<List<Product>> getProductsByTerm(String term);

  Future<Product> createProduct(Map<String, dynamic> productLike);

  Future<Product> updateProduct(Map<String, dynamic> productLike);
}
