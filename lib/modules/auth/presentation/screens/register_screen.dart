import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/modules/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                IconButton(
                  onPressed: () {
                    if (!context.canPop()) return;
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  // 260 = the height of the two sized boxes plus the icon
                  height: size.height - 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          const SizedBox(height: 50),

          Text('Create Account', style: textStyles.titleMedium),

          const SizedBox(height: 50),

          const CustomTextFormField(
            label: 'Full Name',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 30),

          const CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 30),

          const CustomTextFormField(label: 'Password', obscureText: true),

          const SizedBox(height: 30),

          const CustomTextFormField(
            label: 'Confirm password',
            obscureText: true,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Sign Up',
              buttonColor: Colors.black,
              onPressed: () {},
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    return context.pop();
                  }
                  context.go('/login');
                },
                child: const Text('Sign in here.'),
              ),
            ],
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
