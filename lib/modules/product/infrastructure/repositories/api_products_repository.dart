import 'package:teslo_shop/modules/product/domain/datasources/datasources.dart';
import 'package:teslo_shop/modules/product/domain/entities/entities.dart';
import 'package:teslo_shop/modules/product/domain/repositories/repositories.dart';

class ApiProductsRepository extends ProductsRepository {
  final ProductsDatasource productsDatasource;

  ApiProductsRepository(this.productsDatasource);

  @override
  Future<List<Product>> getProductsPaginated({int limit = 10, int offset = 0}) {
    return productsDatasource.getProductsPaginated(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Product> getProductById(String id) {
    return productsDatasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByTerm(String term) {
    return productsDatasource.getProductsByTerm(term);
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    return productsDatasource.createProduct(productLike);
  }

  @override
  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> productLike,
  ) {
    return productsDatasource.updateProduct(productId, productLike);
  }
}
