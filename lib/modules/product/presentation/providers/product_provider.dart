import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/infrastructure/infrastructure.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_provider.dart';
import 'package:teslo_shop/modules/product/presentation/providers/products_repository_provider.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class ProductState {
  final String id;
  final bool isLoading;
  final bool isSaving;
  final SnackbarMessage? message;
  final Product? product;

  ProductState({
    required this.id,
    this.isLoading = false,
    this.isSaving = false,
    this.message,
    this.product,
  });

  ProductState copyWith({
    String? id,
    bool? isLoading,
    bool? isSaving,
    SnackbarMessage? message,
    Product? product,
  }) => ProductState(
    id: id ?? this.id,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    message: message ?? this.message,
    product: product ?? this.product,
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
    } on ProductError catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: SnackbarMessage(e.message, MessageTone.error),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        message: SnackbarMessage('Unhandled error.', MessageTone.error),
      );
    }
  }

  Future<void> saveProduct(Map<String, dynamic> productLike) async {
    if (state.isLoading || state.isSaving) return;

    state = state.copyWith(isSaving: true);

    try {
      final String successMsg;
      final Product product;

      if (state.id != 'new') {
        successMsg = 'Product updated successfully.';
        product = await productsRepository.updateProduct(state.id, productLike);
      } else {
        successMsg = 'Product created successfully.';
        product = await productsRepository.createProduct(productLike);
      }

      state = state.copyWith(
        id: product.id,
        isSaving: false,
        product: product,
        message: SnackbarMessage(successMsg, MessageTone.success),
      );
      ref.read(productsNotifierProvider.notifier).updateOrInsert(product);
    } on ProductError catch (e) {
      state = state.copyWith(
        isSaving: false,
        message: SnackbarMessage(e.message, MessageTone.error),
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        message: SnackbarMessage('Unhandled error.', MessageTone.error),
      );
    }
  }
}

// ? https://riverpod.dev/docs/migration/from_state_notifier#explicit-family-and-autodispose-modifications
final productNotifierProvider = NotifierProvider.family
    .autoDispose<ProductNotifier, ProductState, String>(ProductNotifier.new);
