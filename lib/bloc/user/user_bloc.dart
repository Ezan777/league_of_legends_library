import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/user_event.dart';
import 'package:league_of_legends_library/bloc/user/user_state.dart';
import 'package:league_of_legends_library/core/repository/user_repository.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthSource _authSource;
  final UserRepository _userRepository;

  UserBloc(this._userRepository, this._authSource) : super(UserLoading()) {
    on<UserStarted>(_onStarted);
    on<LogoutButtonPressed>(_logout);
  }

  Future<void> _onStarted(UserStarted event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final appUser = await _userRepository.getCurrentlyLoggedUser();
      if (appUser == null) {
        emit(NoUserLogged());
      } else {
        emit(UserLogged(appUser));
      }
    } catch (e) {
      emit(UserError(e));
    }
  }

  Future<void> _logout(
      LogoutButtonPressed event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _authSource.logout();
      emit(NoUserLogged());
    } catch (e) {
      emit(UserError(e));
    }
  }
}
