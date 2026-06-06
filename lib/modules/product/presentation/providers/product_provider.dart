import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_repository_provider.dart';

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
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
    state = state.copyWith(isLoading: true);

    try {
      final product = await productsRepository.getProductById(state.id);
      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

// ? https://riverpod.dev/docs/migration/from_state_notifier#explicit-family-and-autodispose-modifications
final productNotifierProvider = NotifierProvider.family
    .autoDispose<ProductNotifier, ProductState, String>(ProductNotifier.new);
