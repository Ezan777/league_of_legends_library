import 'package:equatable/equatable.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

final class ChangePasswordIdle extends ChangePasswordState {}

final class ChangingPassword extends ChangePasswordState {}

final class PasswordChanged extends ChangePasswordState {}

final class ChangePasswordError extends ChangePasswordState {
  final Object? error;

  const ChangePasswordError(this.error);

  @override
  List<Object?> get props => [error];
}
