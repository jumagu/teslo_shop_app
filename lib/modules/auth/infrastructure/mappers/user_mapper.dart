import 'package:teslo_shop/modules/auth/domain/domain.dart';

class UserMapper {
  static User apiJsonUserToEntity(Map<String, dynamic> json) => User(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    roles: List<String>.from(json['roles'].map((role) => role)),
    token: json['token'],
  );
}
