import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/list/list_details.dart';
import '../features/home/home.dart';
import '../features/list/pages/addnote.dart';
import '../features/list/pages/sharepage.dart';
import '../features/list/pages/addfriend.dart';
import '../features/list/pages/printpage.dart';

import '../features/auth/presentation/pages/welcome.dart';
import '../features/auth/presentation/pages/signup.dart';
import '../features/auth/presentation/pages/login.dart';
import '../features/auth/bloc/bloc.dart';
import '../features/auth/bloc/state.dart';


GoRouter buildRouter(BuildContext context) {
  final authBloc = context.read<AuthenticationBloc>();

  return GoRouter(
    initialLocation: '/',
    // refresh when the bloc emits new states
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;

      final isLoggedIn = authState is AuthenticationAuthenticated;
      // use state.location (subloc) for current path
      final location = state.matchedLocation;
      final isAuthPage = location == '/login' || location == '/signup';

      // if not logged in and not on welcome/login/signup, send them to welcome
      if (!isLoggedIn && !isAuthPage && location != '/') return '/';
      // if logged in and on auth pages or welcome, send to home
      if (isLoggedIn && (location == '/' || isAuthPage)) return '/home';

      return null; // no redirect
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/addnote', builder: (context, state) => const AddNotePage()),
      GoRoute(path: '/share', builder: (context, state) => const SharePage()),
      GoRoute(path: '/addfriend', builder: (context, state) => const AddFriendPage()),
      GoRoute(path: '/print', builder: (context, state) => const PrintPage()),
      GoRoute(path: '/list/:listName', builder: (context, state)
          {
            final listName = state.pathParameters['listName']!;
            return ListDetailsScreen(listName: listName);
          },
        ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // notify initially so GoRouter evaluates redirect immediately
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

