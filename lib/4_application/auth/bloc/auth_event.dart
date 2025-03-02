import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthMagicLinkRequested extends AuthEvent {
  final String email;

  AuthMagicLinkRequested({required this.email});
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}

class AuthErrorOccurred extends AuthEvent {
  final String errorMessage;

  AuthErrorOccurred(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
