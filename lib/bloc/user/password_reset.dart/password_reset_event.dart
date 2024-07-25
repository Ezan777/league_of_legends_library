import 'package:equatable/equatable.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class PasswordResetButtonPressed extends PasswordResetEvent {
  final String email;

  const PasswordResetButtonPressed(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordView extends PasswordResetEvent {}
