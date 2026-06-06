import 'package:formz/formz.dart';

enum NumberInputError { min, max, isnan }

class NumberInput<T extends num> extends FormzInput<T, NumberInputError> {
  final T? min;
  final T? max;

  const NumberInput.pure(super.value, {this.min, this.max}) : super.pure();

  const NumberInput.dirty(super.value, {this.min, this.max}) : super.dirty();

  String? get errorText {
    if (isValid || isPure) return null;

    switch (displayError) {
      case NumberInputError.isnan:
        return 'Please enter a valid number';

      case NumberInputError.min:
        return 'Minimum value: $min';

      case NumberInputError.max:
        return 'Maximum value: $max';

      default:
        return null;
    }
  }

  @override
  NumberInputError? validator(T value) {
    if (value.isNaN) {
      return NumberInputError.isnan;
    }

    if (min != null && value < min!) {
      return NumberInputError.min;
    }

    if (max != null && value > max!) {
      return NumberInputError.max;
    }

    return null;
  }
}
