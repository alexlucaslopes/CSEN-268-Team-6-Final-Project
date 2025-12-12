import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router.dart';
import 'theme.dart';
import 'package:easy_list/features/auth/bloc/bloc.dart';

class EasyListerApp extends StatefulWidget {
  const EasyListerApp({super.key});

  @override
  State<EasyListerApp> createState() => _EasyListerAppState();
}

class _EasyListerAppState extends State<EasyListerApp> {
  late final dynamic _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthenticationBloc>();
    _router = buildRouter(authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EasyLister',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
