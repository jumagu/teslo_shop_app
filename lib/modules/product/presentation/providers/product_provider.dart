import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_provider.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_repository_provider.dart';

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = false,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
}

class ProductNotifier extends Notifier<ProductState> {
  final String productId;
  late final ProductsRepository productsRepository;

  ProductNotifier(this.productId);

  @override
  ProductState build() {
    productsRepository = ref.read(productsRepositoryProvider);
    Future.microtask(() => loadProduct());
    return ProductState(id: productId);
  }

  Future<void> loadProduct() async {
    if (state.id == 'new') {
      state = state.copyWith(
        isLoading: false,
        product: Product(
          id: 'new',
          title: '',
          price: 0,
          description: '',
          slug: '',
          stock: 0,
          sizes: [],
          gender: 'men',
          tags: [],
          images: [],
        ),
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveProduct(Map<String, dynamic> productLike) async {
    if (state.isLoading || state.isSaving) return;

    state = state.copyWith(isSaving: true);

    try {
      final Product product;

      if (state.id != 'new') {
        product = await productsRepository.updateProduct(
          productId,
          productLike,
        );
      } else {
        product = await productsRepository.createProduct(productLike);
      }

      state = state.copyWith(isSaving: false, product: product);
      ref.read(productsNotifierProvider.notifier).updateOrInsert(product);
    } catch (e) {
      state = state.copyWith(isSaving: false);
    }
  }
}

// ? https://riverpod.dev/docs/migration/from_state_notifier#explicit-family-and-autodispose-modifications
final productNotifierProvider = NotifierProvider.family
    .autoDispose<ProductNotifier, ProductState, String>(ProductNotifier.new);
