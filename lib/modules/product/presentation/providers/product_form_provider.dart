import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

// ? Custom Inputs

class TitleInput extends TextInput {
  const TitleInput.pure() : super.pure('', minLength: 3, maxLength: 40);
  const TitleInput.dirty(super.value) : super.dirty(minLength: 3, maxLength: 40);
}

class SlugInput extends TextInput {
  // RegExp can't be const-constructed, so these constructors can't be const.
  static final _pattern = RegExp(r'^[a-z0-9]+(?:[-_][a-z0-9]+)*$');
  static const _message = 'Only lowercase letters, numbers, single hyphens and underscores';

  SlugInput.pure() : super.pure('', pattern: _pattern, patternMessage: _message);
  SlugInput.dirty(super.value) : super.dirty(pattern: _pattern, patternMessage: _message);
}

class DescriptionInput extends TextInput {
  const DescriptionInput.pure() : super.pure('', minLength: 20, maxLength: 450);
  const DescriptionInput.dirty(super.value) : super.dirty(minLength: 20, maxLength: 450);
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
  static const _message = 'Enter a comma-separated list, e.g. shirt, summer, cotton';

  TagsInput.pure() : super.pure('', pattern: _pattern, patternMessage: _message);
  TagsInput.dirty(super.value) : super.dirty(pattern: _pattern, patternMessage: _message);
}

// ? Product Form Implementation

class ProductFormState {
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

  bool get isValid => Formz.validate([title, slug, description, price, stock, tags]);
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
    state = state.copyWith(title: TitleInput.dirty(value));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(slug: SlugInput.dirty(value));
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(description: DescriptionInput.dirty(value));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(price: PriceInput.dirty(value));
  }

  void onStockChanged(int value) {
    state = state.copyWith(stock: StockInput.dirty(value));
  }

  void onTagsChanged(String value) {
    state = state.copyWith(tags: TagsInput.dirty(value));
  }

  void onSizesChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  Future<void> onSubmit([Function(Map<String, dynamic> productLike)? callback]) async {
    if (!state.isValid) {
      _markAllAsTouched();
      return;
    }

    if (state.isSubmitting) return;

    state = state.copyWith(isSubmitting: true);

    if (callback != null) {
      await callback({
        'title': state.title.value,
        'slug': state.slug.value,
        'description': state.description.value,
        'price': state.price.value,
        'stock': state.stock.value,
        'sizes': state.sizes,
        'gender': state.gender,
        'tags': state.tags.value.split(','),
        'images': state.images
            .map((img) => img.replaceAll('${Environment.apiUrl}/files/product/', ''))
            .toList(),
      });
    }

    state = state.copyWith(isSubmitting: false);
  }

  void _markAllAsTouched() {
    final title = TitleInput.dirty(state.title.value);
    final slug = SlugInput.dirty(state.slug.value);
    final description = DescriptionInput.dirty(state.description.value);
    final price = PriceInput.dirty(state.price.value);
    final stock = StockInput.dirty(state.stock.value);
    final tags = TagsInput.dirty(state.tags.value);

    state = state.copyWith(
      wasSubmitted: true,
      title: title,
      slug: slug,
      description: description,
      price: price,
      stock: stock,
      tags: tags,
    );
  }
}

final productFormNotifierProvider = NotifierProvider.family
    .autoDispose<ProductFormNotifier, ProductFormState, Product>(ProductFormNotifier.new);
