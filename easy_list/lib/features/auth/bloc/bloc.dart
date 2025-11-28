import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async {
    // Later, you can check local storage or Firebase for a token.
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthenticationUnauthenticated());
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationAuthenticated());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationUnauthenticated());
  }
}
