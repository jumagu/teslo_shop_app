import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String initialValue;
  final int maxLines;
  final bool obscureText;
  final double fontSize;
  final TextInputType keyboardType;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String? label;
  final String? hint;
  final String? errorText;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;
  final String? Function(String? value)? validator;

  const CustomTextFormField({
    super.key,
    this.initialValue = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.fontSize = 20,
    this.keyboardType = TextInputType.text,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onFieldSubmitted,
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
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: fontSize, color: Colors.black),
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
        floatingLabelBehavior: floatingLabelBehavior,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
