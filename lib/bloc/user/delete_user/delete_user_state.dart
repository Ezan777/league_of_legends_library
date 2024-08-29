import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';

sealed class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object?> get props => [];
}

final class DeleteUserIdle extends DeleteUserState {
  final AppUser loggedUser;

  const DeleteUserIdle(this.loggedUser);

  @override
  List<Object?> get props => [loggedUser];
}

final class DeleteUserSuccess extends DeleteUserState {}

final class DeleteUserLoading extends DeleteUserState {}

final class DeleteUserError extends DeleteUserState {
  final AppUser appUser;
  final Object? error;

  const DeleteUserError(this.appUser, this.error);

  @override
  List<Object?> get props => [appUser, error];
}
