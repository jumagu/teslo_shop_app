import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const borderRadius = Radius.circular(15);

    final border = OutlineInputBorder(
      borderSide: const BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.only(
        topLeft: borderRadius,
        bottomLeft: borderRadius,
        bottomRight: borderRadius,
      ),
    );

    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: errorText == null ? Colors.white : Colors.red.shade50,
        isDense: true,
        label: label != null ? Text(label!) : null,
        hintText: hint,
        errorText: errorText,
        focusColor: colors.primary,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
