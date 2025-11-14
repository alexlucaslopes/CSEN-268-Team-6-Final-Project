import 'package:easy_list/features/auth/bloc/bloc.dart';
import 'package:easy_list/features/auth/bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => AuthenticationBloc()..add(AppStarted()),
      child: EasyListerApp(),  
    ), 
  );
}
