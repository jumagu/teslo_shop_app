import 'package:formz/formz.dart';

enum PasswordInputError { empty, length, format }

class PasswordInput extends FormzInput<String, PasswordInputError> {
  static final RegExp pwdRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty({String value = ''}) : super.dirty(value);

  String? get errorText {
    if (isValid || isPure) return null;

    if (displayError == PasswordInputError.empty) {
      return 'Password is required';
    }

    if (displayError == PasswordInputError.length) {
      return 'Password must be at least 6 characters length';
    }

    if (displayError == PasswordInputError.format) {
      return 'Password must have at least 1 uppercase letter, 1 lowercase letter and 1 number';
    }

    return null;
  }

  @override
  PasswordInputError? validator(String value) {
    if (value.trim().isEmpty) {
      return PasswordInputError.empty;
    }

    if (value.length < 6) {
      return PasswordInputError.length;
    }

    if (!pwdRegExp.hasMatch(value)) {
      return PasswordInputError.format;
    }

    return null;
  }
}
