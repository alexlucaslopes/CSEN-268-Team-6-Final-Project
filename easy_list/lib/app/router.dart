import 'package:go_router/go_router.dart';
import '../features/list/list_details.dart';
import '../features/auth/presentation/pages/welcome.dart';
import '../features/auth/presentation/pages/signup.dart';
import '../features/auth/presentation/pages/login.dart';
import '../features/home/home.dart';
import '../features/list/pages/addnote.dart';
import '../features/list/pages/sharepage.dart';
import '../features/list/pages/addfriend.dart';
import '../features/list/pages/printpage.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
          path: '/home_share',
          builder: (context, state) {
            final localNotes = state.extra as List<Map<String, String>>?;
            return HomePageShare(localNotes: localNotes ?? []);
          },
        ),
      GoRoute(path: '/addnote', builder: (context, state) => const AddNotePage()),
      GoRoute(
          path: '/share',
          builder: (context, state) {
            final localNotes = state.extra as List<Map<String, String>>?;
            return SharePage(localNotes: localNotes ?? []);
          },
        ),
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
