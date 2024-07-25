import 'package:equatable/equatable.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final String email;
  final String password;

  const SignUpSuccess(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class SignUpError extends SignUpState {
  final Object? error;

  const SignUpError(this.error);

  @override
  List<Object?> get props => [error];
}
