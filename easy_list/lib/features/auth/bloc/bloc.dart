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
    on<LogoutRequested>(_onLogoutRequested);

    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        add(LoggedIn(user: user));
      } else {
        add(LoggedOut());
      }    
    });
  }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(AuthenticationAuthenticated(user: user));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationAuthenticated(user: event.user));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationUnauthenticated());
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
