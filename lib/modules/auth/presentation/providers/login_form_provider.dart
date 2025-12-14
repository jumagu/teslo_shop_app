import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      return LoginFormNotifier();
    });

// ? Defines the shape of the Login form state
class LoginFormState {
  final bool isValid;
  final bool isSubmitting;
  final bool wasSubmitted;
  final EmailInput email;
  final PasswordInput password;

  LoginFormState({
    this.isValid = false,
    this.isSubmitting = false,
    this.wasSubmitted = false,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
  });

  @override
  String toString() {
    return 'isValid: $isValid\nisSubmitting: $isSubmitting\nwasSubmitted: $wasSubmitted\nemail: $email\npassword: $password';
  }

  LoginFormState copyWith({
    bool? isValid,
    bool? isSubmitting,
    bool? wasSubmitted,
    EmailInput? email,
    PasswordInput? password,
  }) => LoginFormState(
    isValid: isValid ?? this.isValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    wasSubmitted: wasSubmitted ?? this.wasSubmitted,
    email: email ?? this.email,
    password: password ?? this.password,
  );
}

// ? Handles the Login form state
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  void onEmailChanged(String value) {
    final newEmail = EmailInput.dirty(value: value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  void onPasswordChanged(String value) {
    final newPwd = PasswordInput.dirty(value: value);

    state = state.copyWith(
      password: newPwd,
      isValid: Formz.validate([newPwd, state.email]),
    );
  }

  void onSubmit() {
    if (!state.isValid) {
      _markAllAsTouched();
      return;
    }
  }

  void _markAllAsTouched() {
    final email = EmailInput.dirty(value: state.email.value);
    final password = PasswordInput.dirty(value: state.password.value);

    state = state.copyWith(
      isValid: Formz.validate([email, password]),
      wasSubmitted: true,
      email: email,
      password: password,
    );
  }
}
