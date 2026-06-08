import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';
import 'package:teslo_shop/modules/product/presentation/providers/providers.dart';
import 'package:teslo_shop/modules/product/presentation/widgets/widgets.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider(productId));
    final product = productState.product;

    void onSubmit() {
      if (product == null) return;

      final formNotifier = ref.read(productFormNotifierProvider(product).notifier);
      final productNotifier = ref.read(productNotifierProvider(productId).notifier);

      formNotifier.onSubmit(productNotifier.saveProduct);
    }

    return GestureDetector(
      // onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // ? Another way to remove the keyboard focus
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(productId == 'new' ? 'Add Product' : 'Edit Product'),
          actions: [IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {})],
        ),
        body: product == null ? const FullScreenLoader() : _ProductView(product),
        floatingActionButton: FloatingActionButton(
          onPressed: onSubmit,
          child: Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView(this.product);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormNotifierProvider(product));

    return SingleChildScrollView(
      child: Column(
        spacing: 25,
        children: [
          AspectRatio(aspectRatio: 1, child: _ImageGallery(images: productForm.images)),

          _ProductInformation(product),

          const SizedBox(height: 65),
        ],
      ),
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;

  const _ProductInformation(this.product);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final productForm = ref.watch(productFormNotifierProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productForm.title.value, style: textStyles.titleMedium?.copyWith(height: 1.2)),

          Divider(),

          Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General Information',
                style: textStyles.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1,
                ),
              ),

              ProductTextFormField(
                label: 'Name',
                hint: 'E.g. Awesome T-Shirt',
                initialValue: productForm.title.value,
                errorText: productForm.title.errorText,
                onChanged: ref.read(productFormNotifierProvider(product).notifier).onTitleChanged,
              ),

              ProductTextFormField(
                label: 'Slug',
                hint: 'E.g. awesome_tshirt',
                initialValue: productForm.slug.value,
                errorText: productForm.slug.errorText,
                onChanged: ref.read(productFormNotifierProvider(product).notifier).onSlugChanged,
              ),

              ProductTextFormField(
                label: 'Price',
                hint: 'E.g. 4.99',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                initialValue: productForm.price.value.toString(),
                errorText: productForm.price.errorText,
                onChanged: (value) => ref
                    .read(productFormNotifierProvider(product).notifier)
                    .onPriceChanged(double.tryParse(value) ?? double.nan),
              ),
            ],
          ),

          Divider(),

          Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Additional Information',
                style: textStyles.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1,
                ),
              ),

              _GenderSelector(
                selectedGender: productForm.gender,
                onSelectionChanged: ref
                    .read(productFormNotifierProvider(product).notifier)
                    .onGenderChanged,
              ),

              _SizeSelector(
                selectedSizes: productForm.sizes,
                onSelectionChanged: ref
                    .read(productFormNotifierProvider(product).notifier)
                    .onSizesChanged,
              ),

              ProductTextFormField(
                label: 'Stock',
                hint: 'E.g. 1000',
                keyboardType: const TextInputType.numberWithOptions(),
                initialValue: productForm.stock.value.toString(),
                errorText: productForm.stock.errorText,
                onChanged: (value) => ref
                    .read(productFormNotifierProvider(product).notifier)
                    .onStockChanged(int.tryParse(value) ?? 0),
              ),

              ProductTextFormField(
                maxLines: 6,
                label: 'Description',
                hint:
                    'E.g. "100% cotton t-shirt, regular fit, available in sizes S–XL. Perfect for casual or sporty looks."',
                keyboardType: TextInputType.multiline,
                initialValue: productForm.description.value,
                errorText: productForm.description.errorText,
                onChanged: ref
                    .read(productFormNotifierProvider(product).notifier)
                    .onDescriptionChanged,
              ),

              ProductTextFormField(
                label: 'Tags (Separated by comma)',
                hint: 'E.g. shirt, summer, cotton',
                initialValue: productForm.tags.value,
                errorText: productForm.tags.errorText,
                onChanged: ref.read(productFormNotifierProvider(product).notifier).onTagsChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final void Function(List<String> selectedSizes)? onSelectionChanged;

  const _SizeSelector({required this.selectedSizes, this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        showSelectedIcon: false,
        emptySelectionAllowed: true,
        segments: sizes.map((size) {
          return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        selected: Set.from(selectedSizes),
        onSelectionChanged: (newSelection) {
          onSelectionChanged?.call(List.from(newSelection));
        },
        multiSelectionEnabled: true,
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['Men', 'Women', 'Kid'];
  final List<IconData> genderIcons = const [Icons.man, Icons.woman, Icons.boy];
  final void Function(String selectedGender)? onSelectionChanged;

  const _GenderSelector({required this.selectedGender, this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        showSelectedIcon: false,
        multiSelectionEnabled: false,
        segments: genders.map((gender) {
          return ButtonSegment(
            icon: Icon(genderIcons[genders.indexOf(gender)]),
            value: gender.toLowerCase(),
            label: Text(gender, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onSelectionChanged?.call(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: images.isEmpty
          ? [Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover)]
          : images.map((e) => Image.network(e, fit: BoxFit.cover)).toList(),
    );
  }
}
