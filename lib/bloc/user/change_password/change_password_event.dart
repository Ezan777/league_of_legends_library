import 'package:equatable/equatable.dart';

class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class ChangePassword extends ChangePasswordEvent {
  final String email, oldPassword, newPassword;

  const ChangePassword(this.email, this.newPassword, this.oldPassword);

  @override
  List<Object?> get props => [email, oldPassword, newPassword];
}
