part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [];
}
