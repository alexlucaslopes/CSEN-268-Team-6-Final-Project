import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Icon(Icons.person, size: 100, color: Colors.black54),
              const SizedBox(height: 40),
              AuthTextField(hint:'username', controller: usernameController, obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint:'email', controller: emailController, obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint:'password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              AuthButton(
                label: 'Sign Up',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

}