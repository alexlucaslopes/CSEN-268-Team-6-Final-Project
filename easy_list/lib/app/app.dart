import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'theme.dart';

class EasyListerApp extends StatelessWidget {
  const EasyListerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = buildRouter();

    return MaterialApp.router(
      title: 'EasyLister',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
