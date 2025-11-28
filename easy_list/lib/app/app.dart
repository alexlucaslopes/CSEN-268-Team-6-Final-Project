import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'router.dart';
import 'theme.dart';
import 'package:easy_list/features/auth/bloc/bloc.dart';



class EasyListerApp extends StatelessWidget {
  const EasyListerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthenticationBloc>();
    //final GoRouter router = buildRouter(context);

    return MaterialApp.router(
      title: 'EasyLister',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: buildRouter(authBloc),
    );
  }
}
