import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  bool operator ==(Object other) => other is AuthenticationInitial;
  @override
  int get hashCode => 0;
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  bool operator ==(Object other) => other is AuthenticationUnauthenticated;
  @override
  int get hashCode => 1;
}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;
  const AuthenticationAuthenticated({required this.user});

  @override
  bool operator ==(Object other) => 
    other is AuthenticationAuthenticated && other.user.uid == user.uid;
  
  @override
  int get hashCode => user.uid.hashCode;
}
