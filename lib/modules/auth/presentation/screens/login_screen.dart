import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/modules/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 100,
                ),

                const SizedBox(height: 80),

                Container(
                  // 260 = the height of the two sized boxes plus the icon
                  height: size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormState = ref.watch(loginFormProvider);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          const SizedBox(height: 50),

          Text('Login', style: textStyles.titleLarge),

          const SizedBox(height: 50),

          CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            errorText: loginFormState.wasSubmitted
                ? loginFormState.email.errorText
                : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            errorText: loginFormState.wasSubmitted
                ? loginFormState.password.errorText
                : null,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Sign in',
              buttonColor: Colors.black,
              onPressed: ref.read(loginFormProvider.notifier).onSubmit,
            ),
          ),

          const Spacer(flex: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an acount?"),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Sign up here.'),
              ),
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
