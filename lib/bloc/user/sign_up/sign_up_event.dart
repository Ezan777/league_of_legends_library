import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  final String email, password, summonerName, name, surname;

  const SignUpButtonPressed(
      this.email, this.password, this.summonerName, this.name, this.surname);

  @override
  List<Object?> get props => [email, password];
}

class ResetSignUpView extends SignUpEvent {}
