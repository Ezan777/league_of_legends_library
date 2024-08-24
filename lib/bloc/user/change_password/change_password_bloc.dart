import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_event.dart';
import 'package:league_of_legends_library/bloc/user/change_password/change_password_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthSource _authSource;

  ChangePasswordBloc(this._authSource) : super(ChangePasswordIdle()) {
    on<ChangePassword>(_changePassword);
  }

  Future<void> _changePassword(
      ChangePassword event, Emitter<ChangePasswordState> emit) async {
    emit(ChangingPassword());
    try {
      if (await _authSource.checkCredentials(event.email, event.oldPassword)) {
        await _authSource.changePassword(event.newPassword);
        emit(PasswordChanged());
      } else {
        emit(ChangePasswordError(InvalidCredentials()));
      }
    } catch (e) {
      emit(ChangePasswordError(e));
    }
  }
}
