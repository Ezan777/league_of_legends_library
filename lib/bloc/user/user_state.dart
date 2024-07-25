import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserLoading extends UserState {}

final class UserLogged extends UserState {
  final AppUser appUser;

  const UserLogged(this.appUser);

  @override
  List<Object?> get props => [appUser];
}

final class NoUserLogged extends UserState {}

final class UserError extends UserState {
  final Object? error;

  const UserError(this.error);

  @override
  List<Object?> get props => [error];
}
