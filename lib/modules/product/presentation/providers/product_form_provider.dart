import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

// ? Custom Inputs

class TitleInput extends TextInput {
  const TitleInput.pure() : super.pure('', minLength: 3, maxLength: 40);
  const TitleInput.dirty(super.value)
    : super.dirty(minLength: 3, maxLength: 40);
}

class SlugInput extends TextInput {
  // RegExp can't be const-constructed, so these constructors can't be const.
  static final _pattern = RegExp(r'^[a-z0-9]+(?:[-_][a-z0-9]+)*$');
  static const _message =
      'Only lowercase letters, numbers, single hyphens and underscores';

  SlugInput.pure()
    : super.pure('', pattern: _pattern, patternMessage: _message);
  SlugInput.dirty(super.value)
    : super.dirty(pattern: _pattern, patternMessage: _message);
}

class DescriptionInput extends TextInput {
  const DescriptionInput.pure() : super.pure('', minLength: 20, maxLength: 450);
  const DescriptionInput.dirty(super.value)
    : super.dirty(minLength: 20, maxLength: 450);
}

class PriceInput extends NumberInput<double> {
  const PriceInput.pure() : super.pure(0, min: 0);
  const PriceInput.dirty(super.value) : super.dirty(min: 0);
}

class StockInput extends NumberInput<int> {
  const StockInput.pure() : super.pure(0, min: 0, max: 10000);
  const StockInput.dirty(super.value) : super.dirty(min: 0, max: 10000);
}

class TagsInput extends TextInput {
  static final _pattern = RegExp(r'^[^\s,]+(\s*,\s*[^\s,]+)*$');
  static const _message =
      'Enter a comma-separated list, e.g. shirt, summer, cotton';

  TagsInput.pure()
    : super.pure('', pattern: _pattern, patternMessage: _message);
  TagsInput.dirty(super.value)
    : super.dirty(pattern: _pattern, patternMessage: _message);
}

// ? Product Form Implementation

class ProductFormState {
  final bool isValid;
  final bool isSubmitting;
  final bool wasSubmitted;
  final TitleInput title;
  final SlugInput slug;
  final DescriptionInput description;
  final PriceInput price;
  final StockInput stock;
  final List<String> sizes;
  final String gender;
  final TagsInput tags;
  final List<String> images;
  final String? id;

  ProductFormState({
    this.isValid = false,
    this.isSubmitting = false,
    this.wasSubmitted = false,
    this.title = const TitleInput.pure(),
    SlugInput? slug,
    this.description = const DescriptionInput.pure(),
    this.price = const PriceInput.pure(),
    this.stock = const StockInput.pure(),
    this.sizes = const [],
    this.gender = 'unisex',
    TagsInput? tags,
    this.images = const [],
    this.id,
  }) : slug = slug ?? SlugInput.pure(),
       tags = tags ?? TagsInput.pure();

  ProductFormState copyWith({
    bool? isValid,
    bool? isSubmitting,
    bool? wasSubmitted,
    TitleInput? title,
    SlugInput? slug,
    DescriptionInput? description,
    PriceInput? price,
    StockInput? stock,
    List<String>? sizes,
    String? gender,
    TagsInput? tags,
    List<String>? images,
    String? id,
  }) => ProductFormState(
    isValid: isValid ?? this.isValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    wasSubmitted: wasSubmitted ?? this.wasSubmitted,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    description: description ?? this.description,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    tags: tags ?? this.tags,
    images: images ?? this.images,
    id: id ?? this.id,
  );
}

class ProductFormNotifier extends Notifier<ProductFormState> {
  final Product product;

  ProductFormNotifier(this.product);

  @override
  ProductFormState build() => ProductFormState(
    title: TitleInput.dirty(product.title),
    slug: SlugInput.dirty(product.slug),
    description: DescriptionInput.dirty(product.description),
    price: PriceInput.dirty(product.price),
    stock: StockInput.dirty(product.stock),
    sizes: product.sizes,
    gender: product.gender,
    tags: TagsInput.dirty(product.tags.join(',')),
    images: product.images,
    id: product.id,
  );

  void onTitleChanged(String value) {
    final newTitle = TitleInput.dirty(value);

    state = state.copyWith(
      title: newTitle,
      isValid: Formz.validate([
        newTitle,
        state.slug,
        state.description,
        state.price,
        state.stock,
        state.tags,
      ]),
    );
  }

  void onSlugChanged(String value) {
    final newSlug = SlugInput.dirty(value);

    state = state.copyWith(
      slug: newSlug,
      isValid: Formz.validate([
        newSlug,
        state.title,
        state.description,
        state.price,
        state.stock,
        state.tags,
      ]),
    );
  }

  void onDescriptionChanged(String value) {
    final newDescription = DescriptionInput.dirty(value);

    state = state.copyWith(
      description: newDescription,
      isValid: Formz.validate([
        newDescription,
        state.title,
        state.slug,
        state.price,
        state.stock,
        state.tags,
      ]),
    );
  }

  void onPriceChanged(double value) {
    final newPrice = PriceInput.dirty(value);

    state = state.copyWith(
      price: newPrice,
      isValid: Formz.validate([
        newPrice,
        state.title,
        state.slug,
        state.description,
        state.stock,
        state.tags,
      ]),
    );
  }

  void onStockChanged(int value) {
    final newStock = StockInput.dirty(value);

    state = state.copyWith(
      stock: newStock,
      isValid: Formz.validate([
        newStock,
        state.title,
        state.slug,
        state.description,
        state.price,
        state.tags,
      ]),
    );
  }

  void onTagsChanged(String value) {
    final newTags = TagsInput.dirty(value);

    state = state.copyWith(
      tags: newTags,
      isValid: Formz.validate([
        newTags,
        state.title,
        state.slug,
        state.description,
        state.stock,
        state.price,
      ]),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  Future<void> onSubmit([
    Function(Map<String, dynamic> productLike)? callback,
  ]) async {
    if (!state.isValid) {
      _markAllAsTouched();
      return;
    }

    state = state.copyWith(isSubmitting: true);

    if (callback != null) {
      // await callback();
    }

    state = state.copyWith(isSubmitting: false);
  }

  void _markAllAsTouched() {
    final title = TitleInput.dirty(state.title.value);

    state.copyWith(
      isValid: Formz.validate([title]),
      wasSubmitted: true,
      title: title,
    );
  }
}

final productFormNotifierProvider = NotifierProvider.family
    .autoDispose<ProductFormNotifier, ProductFormState, Product>(
      ProductFormNotifier.new,
    );
