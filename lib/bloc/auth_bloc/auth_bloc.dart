import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elpee/firestore/auth.dart';
import 'package:flutter/services.dart';
import '../bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BaseAuth authRepository;
  final String err = 'Something went wrong, please try again later.';

  AuthBloc(this.authRepository);

  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield AuthLoadInProgress();
    if (event is SignUpWithEmail) {
      try {
        final user = await authRepository.signUp(event.email, event.password);
        yield AuthenticatedState(user);
      } on PlatformException catch (e) {
        yield AuthError(e.message);
      }
    } else if (event is SignInWithEmail) {
      try {
        final user = await authRepository.signIn(event.email, event.password);
        yield AuthenticatedState(user);
      } on PlatformException catch (e) {
        yield AuthError(_parseError(e));
      }
    } else if (event is FetchUser) {
      try {
        final user = await authRepository.getCurrentUser();
        if (user != null) {
          yield AuthenticatedState(user);
        } else {
          yield UnauthenticatedState();
        }
      } on Error {
        yield AuthError(err);
      }
    } else if (event is ForgotPasswordEvent) {
      try {
        await authRepository.forgotPassword(event.email);
        yield UnauthenticatedState();
      } on PlatformException catch (e) {
        yield AuthError(_parseError(e));
      }
    } else if (event is SignOut) {
      try {
        await authRepository.signOut();
        yield UnauthenticatedState();
      } on PlatformException catch (e) {
        yield AuthError(_parseError(e));
      }
    } else if (event is ChangePassword) {
      try {
        await authRepository.changePassword(event.currentPassword, event.newPassword);
        final user = await authRepository.getCurrentUser();
        yield AuthenticatedState(user);
      } on PlatformException catch (e) {
        yield AuthError(_parseError(e));
      }
    } else if (event is DeleteAccount) {
      try {
        String result = await authRepository.deleteAccount(event.password);
        yield UnauthenticatedState();
        yield DeleteSuccessfulState(result);
      } on PlatformException catch (e) {
        yield AuthError(_parseError(e));
      }
    }
  }

  String _parseError(PlatformException e) {
    switch (e.code) {
      case 'ERROR_WRONG_PASSWORD':
        return 'Wrong password. Please try again.';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Too many requests. Please try again later.';
        break;
      case 'ERROR_INVALID_EMAIL':
        return 'The email address is invalid.';
        break;
      case 'ERROR_USER_DISABLED':
        return 'This account has been disabled.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        return 'This email address is not in use.';
        break;
      default:
        return 'Something went wrong. Please try again later.';
        break;
    }
  }
}
