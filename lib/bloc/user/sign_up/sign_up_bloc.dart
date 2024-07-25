import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_event.dart';
import 'package:league_of_legends_library/bloc/user/sign_up/sign_up_state.dart';
import 'package:league_of_legends_library/core/model/app_user.dart';
import 'package:league_of_legends_library/core/repository/user_repository.dart';
import 'package:league_of_legends_library/data/auth_source.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthSource _authSource;
  final UserRepository _userRepository;

  SignUpBloc(this._authSource, this._userRepository) : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_signUp);
    on<ResetSignUpView>(_resetSignUpView);
  }

  Future<void> _signUp(
      SignUpButtonPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final userId = await _authSource.singUp(event.email, event.password);
      if (userId != null) {
        final appUser = AppUser(
          id: userId,
          email: event.email,
          summonerName: event.summonerName,
          name: event.name,
          surname: event.surname,
        );
        try {
          await _userRepository.saveUser(appUser);
        } catch (_) {
          await _authSource.deleteUser(event.email, event.password);
          rethrow;
        }
        emit(SignUpSuccess(event.email, event.password));
      } else {
        emit(const SignUpError(null));
      }
    } catch (e) {
      emit(SignUpError(e));
    }
  }

  void _resetSignUpView(ResetSignUpView event, Emitter<SignUpState> emit) {
    emit(SignUpInitial());
  }
}
