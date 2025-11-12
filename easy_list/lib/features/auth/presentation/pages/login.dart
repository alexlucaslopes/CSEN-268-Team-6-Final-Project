import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              AuthTextField(hint: 'username or email', controller: emailController,obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint: 'password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              AuthButton(
                label: 'Login',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}