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

      GoRoute(
        path: '/addnote',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddNotePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      ),

      GoRoute(
        path: '/addfriend',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddFriendPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      ),

      GoRoute(
        path: '/share',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SharePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      ),

      GoRoute(
        path: '/list/:listName',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: ListDetailsScreen(listName: state.pathParameters['listName']!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            );
          },
        ),
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
