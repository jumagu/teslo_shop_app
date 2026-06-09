import 'package:flutter/material.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ImageViewer(images: product.images),

        Text(product.title, textAlign: TextAlign.left),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;

  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1.0 / 1.0,
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1.0 / 1.0,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(images.first),
          fadeInCurve: Curves.easeOutExpo,
          fadeInDuration: Duration(milliseconds: 125),
          fadeOutDuration: Duration(milliseconds: 333),
          placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
        ),
      ),
    );
  }
}
