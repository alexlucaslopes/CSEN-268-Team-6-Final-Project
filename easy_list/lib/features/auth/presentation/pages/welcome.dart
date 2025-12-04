import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//import '../widgets/auth_button.dart';
import '../widgets/list_writing.dart';
import '../widgets/bullet_points.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWriting(                     // <-- REPLACE old Text()
                text: 'Welcome to EasyLister!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                speed: Duration(milliseconds: 60), // typing speed
              ),

              const SizedBox(height: 40),

              AnimatedBulletButton(
                label: 'Get Started',
                onPressed: () => context.go('/signup'),
                delay: const Duration(milliseconds: 2000),
              ),

              const SizedBox(height: 20),

              AnimatedBulletButton(
                label: 'Log In',
                onPressed: () => context.go('/login'),
                delay: const Duration(milliseconds: 3000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
