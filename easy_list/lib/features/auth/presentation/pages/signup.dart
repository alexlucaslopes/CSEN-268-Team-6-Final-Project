import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Icon(Icons.person, size: 100, color: Colors.black54),
              const SizedBox(height: 40),
              AuthTextField(hint: 'username', controller: usernameController, obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint: 'email', controller: emailController, obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint: 'password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              AuthButton(
                label: 'Sign Up',
                onPressed: () async {
                  try {
                    final safeEmail = emailController.text.trim().toLowerCase();

                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: safeEmail,
                      password: passwordController.text.trim(),
                    );

                    if (userCredential.user != null) {
                      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                        'username': usernameController.text.trim(),
                        'email': safeEmail,
                        'uid': userCredential.user!.uid,
                        'friends': [], 
                        'friendRequestsSent': [],
                        'friendRequestsReceived': [],
                      });
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text("Already have an account? Log In", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}