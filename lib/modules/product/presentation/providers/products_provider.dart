import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_repository_provider.dart';

class ProductsState {
  final bool isLastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.isLoading = false,
    this.limit = 10,
    this.offset = 0,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    isLoading: isLoading ?? this.isLoading,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    products: products ?? this.products,
  );
}

class ProductsNotifier extends Notifier<ProductsState> {
  late final ProductsRepository productsRepository;

  @override
  ProductsState build() {
    productsRepository = ref.watch(productsRepositoryProvider);
    return ProductsState();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    try {
      final products = await productsRepository.getProductsPaginated(
        limit: state.limit,
        offset: state.offset,
      );

      if (products.isEmpty) {
        state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLastPage: false,
        offset: state.offset + state.limit,
        products: [...state.products, ...products],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isLastPage: true);
    }
  }

  void updateOrInsert(Product product) {
    final exist = state.products.any((p) => p.id == product.id);

    if (exist) {
      final updatedProducts = state.products.map((p) => p.id == product.id ? product : p).toList();
      state = state.copyWith(products: updatedProducts);
      return;
    }

    state = state.copyWith(products: [product, ...state.products]);
  }
}

final productsNotifierProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);
