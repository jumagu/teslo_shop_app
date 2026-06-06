import 'package:flutter/material.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class ProductTextFormField extends CustomTextFormField {
  const ProductTextFormField({
    super.key,
    super.initialValue,
    super.maxLines,
    super.obscureText,
    super.keyboardType,
    super.label,
    super.hint,
    super.errorText,
    super.onChanged,
    super.onFieldSubmitted,
    super.validator,
  }) : super(fontSize: 16, floatingLabelBehavior: FloatingLabelBehavior.always);
}
