import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/auth/auth.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/infrastructure/infrastructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authNotifierProvider).user?.token ?? '';

  return ApiProductsRepository(ApiProductsDatasource(accessToken: accessToken));
});
