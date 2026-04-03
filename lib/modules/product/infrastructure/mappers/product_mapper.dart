import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/modules/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/modules/product/domain/domain.dart';

class ProductMapper {
  static Product apiJsonProductToEntity(Map<String, dynamic> json) {
    final images = List<String>.from(
      json['images'].map(
        (img) => img.startsWith('http')
            ? img
            : '${Environment.apiUrl}/files/product/$img',
      ),
    );

    return Product(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tag) => tag)),
      user: UserMapper.apiJsonUserToEntity(json['user']),
      images: images,
    );
  }
}
