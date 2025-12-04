import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/list/list_details.dart';
import '../features/home/home.dart';
import '../features/list/pages/addnote.dart';
import '../features/list/pages/sharepage.dart';
import '../features/list/pages/addfriend.dart';
import '../features/auth/presentation/pages/welcome.dart';
import '../features/auth/presentation/pages/signup.dart';
import '../features/auth/presentation/pages/login.dart';
import '../features/auth/bloc/bloc.dart';
import '../features/auth/bloc/state.dart';

GoRouter buildRouter(AuthenticationBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is AuthenticationAuthenticated;
      final location = state.matchedLocation;
      final isAuthPage = location == '/login' || location == '/signup';

      if (!isLoggedIn && !isAuthPage && location != '/') return '/';
      if (isLoggedIn && (location == '/' || isAuthPage)) return '/home';

      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (_, __) => const WelcomePage()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(path: '/addnote', builder: (_, __) => const AddNotePage()),
      GoRoute(path: '/share', builder: (_, __) => const SharePage()),
      GoRoute(path: '/addfriend', builder: (_, __) => const AddFriendPage()),
            
      GoRoute(
        path: '/list/:listName',
        builder: (_, state) =>
            ListDetailsScreen(listName: state.pathParameters['listName']!),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
