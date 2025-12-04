import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;
  LoggedIn({required this.user});
}

class LoggedOut extends AuthenticationEvent {}
