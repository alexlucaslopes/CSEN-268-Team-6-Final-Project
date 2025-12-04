import 'package:easy_list/features/auth/bloc/bloc.dart';
import 'package:easy_list/features/auth/bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase BEFORE runApp()
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Ignore duplicate app error (happens on hot reload)
    if (!e.toString().contains("duplicate-app")) rethrow;
  }
  
  runApp(
    BlocProvider(
      create: (_) => AuthenticationBloc()..add(AppStarted()),
      child: const EasyListerApp(),
    ),
  );
}