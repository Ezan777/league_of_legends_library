import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/login/login_event.dart';
import 'package:league_of_legends_library/bloc/user/login/login_state.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthSource _authSource;

  LoginBloc(this._authSource) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoginStarted>((event, emit) {
      emit(LoginInitial());
    });
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await _authSource.login(event.email, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e));
    }
  }
}
