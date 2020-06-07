import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignUpWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignUpWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInAsGuest extends AuthEvent {
  const SignInAsGuest();

  @override
  List<Object> get props => [];
}

class FetchUser extends AuthEvent {
  const FetchUser();

  @override
  List<Object> get props => [];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class SignOut extends AuthEvent {
  const SignOut();

  @override
  List<Object> get props => [];
}

class ChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword(this.currentPassword, this.newPassword);

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class DeleteAccount extends AuthEvent {
  final String password;

  const DeleteAccount(this.password);

  @override
  List<Object> get props => [password];
}
