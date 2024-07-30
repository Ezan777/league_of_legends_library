import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserStarted extends UserEvent {}

class LogoutButtonPressed extends UserEvent {}

class UpdateUserData extends UserEvent {
  final AppUser newUser;

  const UpdateUserData(this.newUser);

  @override
  List<Object?> get props => [newUser];
}
