import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_event.dart';
import 'package:league_of_legends_library/bloc/user/delete_user/delete_user_state.dart';
import 'package:league_of_legends_library/core/repository/user_repository.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {
  final UserRepository _userRepository;
  final AuthSource _authSource;

  DeleteUserBloc(this._userRepository, this._authSource)
      : super(DeleteUserLoading()) {
    on<DeleteUser>(_deleteUser);
    on<DeleteUserStarted>(_onStarted);
  }

  Future<void> _deleteUser(
      DeleteUser event, Emitter<DeleteUserState> emit) async {
    emit(DeleteUserLoading());
    bool isUserDataDeleted = false;

    if (event.appUser.email != event.email) {
      emit(DeleteUserError(event.appUser, InvalidCredentials()));
      return;
    }

    try {
      await _userRepository.deleteUserData(event.appUser);
      isUserDataDeleted = true;
      await _authSource.deleteUser(event.email, event.password);
      emit(DeleteUserSuccess());
    } catch (e) {
      if (isUserDataDeleted) {
        _userRepository.saveUser(event.appUser);
      }
      emit(DeleteUserError(event.appUser, e));
    }
  }

  FutureOr<void> _onStarted(
      DeleteUserStarted event, Emitter<DeleteUserState> emit) {
    emit(DeleteUserIdle(event.loggedUser));
  }
}
