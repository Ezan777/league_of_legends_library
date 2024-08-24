import 'package:equatable/equatable.dart';

sealed class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

final class PasswordResetInitial extends PasswordResetState {}

final class PasswordResetLoading extends PasswordResetState {}

final class PasswordResetSuccess extends PasswordResetState {
  final String email;

  const PasswordResetSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

final class PasswordResetError extends PasswordResetState {}
