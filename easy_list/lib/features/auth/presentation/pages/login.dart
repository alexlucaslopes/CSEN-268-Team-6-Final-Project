import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              const SizedBox(height: 50),
              const Icon(Icons.lock_open, size: 80, color: Colors.blue),
              const SizedBox(height: 30),
              
              AuthTextField(hint: 'email', controller: emailController, obscure: false),
              const SizedBox(height: 15),
              AuthTextField(hint: 'password', controller: passwordController, obscure: true),
              const SizedBox(height: 30),
              
              AuthButton(
                label: 'Login',
                onPressed: () async {
                  try {
                    // Log In
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim().toLowerCase(), // Force lowercase
                      password: passwordController.text.trim(),
                    );

                    // Check if Firestore doc exists. create it if no.
                    if (credential.user != null) {
                      final userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
                      
                      if (!userDoc.exists) {
                         await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
                          'username': credential.user!.email!.split('@')[0], // Default username
                          'email': credential.user!.email,
                          'uid': credential.user!.uid,
                          'friends': [], 
                          'friendRequestsSent': [],
                          'friendRequestsReceived': [],
                        });
                      }
                    }
                    // navigation handled by bloc
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed. Check credentials.")));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}