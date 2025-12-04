import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);

    // Listen to Firebase Auth changes in real-time
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(LoggedIn());
      } else {
        add(LoggedOut());
      }
    });
  }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationAuthenticated());
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(AuthenticationUnauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}