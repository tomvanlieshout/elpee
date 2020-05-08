import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  
  @override
  List<Object> get props => [];
}

class AuthLoadInProgress extends AuthState {
  const AuthLoadInProgress();
    
  @override
  List<Object> get props => [];
}

class AuthenticatedState extends AuthState {
  final FirebaseUser user;

  const AuthenticatedState(this.user);
    
  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();

  @override
  List<Object> get props => [];
}

class DeleteSuccessfulState extends AuthState {
  final String result;
  const DeleteSuccessfulState(this.result);

  @override
  List<Object> get props => [result];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}