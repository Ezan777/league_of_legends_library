import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';

class DeleteUserEvent extends Equatable {
  const DeleteUserEvent();

  @override
  List<Object?> get props => [];
}

class DeleteUserStarted extends DeleteUserEvent {
  final AppUser loggedUser;

  const DeleteUserStarted(this.loggedUser);

  @override
  List<Object?> get props => [loggedUser];
}

class DeleteUser extends DeleteUserEvent {
  final AppUser appUser;
  final String email, password;
  const DeleteUser(this.appUser, this.email, this.password);

  @override
  List<Object?> get props => [appUser];
}
