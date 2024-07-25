import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_event.dart';
import 'package:league_of_legends_library/bloc/user/password_reset.dart/password_reset_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthSource _authSource;
  PasswordResetBloc(this._authSource) : super(PasswordResetInitial()) {
    on<PasswordResetButtonPressed>(_sendPasswordResetEmail);
    on<ResetPasswordView>(_resetView);
  }

  Future<void> _sendPasswordResetEmail(PasswordResetButtonPressed event,
      Emitter<PasswordResetState> emit) async {
    emit(PasswordResetLoading());
    try {
      await _authSource.sendPasswordReset(event.email);
      emit(PasswordResetSuccess(event.email));
    } catch (e) {
      emit(PasswordResetError());
    }
  }

  void _resetView(ResetPasswordView event, Emitter<PasswordResetState> emit) {
    emit(PasswordResetInitial());
  }
}
