import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    
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
                onPressed: () {
                  context.read<AuthenticationBloc>().add(LoggedIn());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}