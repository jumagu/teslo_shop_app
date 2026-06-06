import 'package:formz/formz.dart';

enum TextInputError { empty, minlength, maxlength, pattern }

class TextInput extends FormzInput<String, TextInputError> {
  final int? minLength;
  final int? maxLength;
  final RegExp? pattern;
  final String? patternMessage;

  const TextInput.pure(
    super.value, {
    this.minLength,
    this.maxLength,
    this.pattern,
    this.patternMessage,
  }) : super.pure();

  const TextInput.dirty(
    super.value, {
    this.minLength,
    this.maxLength,
    this.pattern,
    this.patternMessage,
  }) : super.dirty();

  String? get errorText {
    if (isValid || isPure) return null;

    switch (displayError) {
      case TextInputError.empty:
        return 'This field is required';

      case TextInputError.minlength:
        return 'Minimum $minLength characters';

      case TextInputError.maxlength:
        return 'Maximum $maxLength characters';

      case TextInputError.pattern:
        return patternMessage ?? 'Invalid format';

      default:
        return null;
    }
  }

  @override
  TextInputError? validator(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return TextInputError.empty;
    }

    if (minLength != null && trimmedValue.length < minLength!) {
      return TextInputError.minlength;
    }

    if (maxLength != null && trimmedValue.length > maxLength!) {
      return TextInputError.maxlength;
    }

    if (pattern != null && !pattern!.hasMatch(trimmedValue)) {
      return TextInputError.pattern;
    }

    return null;
  }
}
