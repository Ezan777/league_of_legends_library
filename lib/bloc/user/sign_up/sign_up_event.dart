import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/data/riot_api.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  final String email, password, summonerName, tagLine, name, surname;
  final RiotServer server;

  const SignUpButtonPressed(
    this.email,
    this.password,
    this.summonerName,
    this.tagLine,
    this.server,
    this.name,
    this.surname,
  );

  @override
  List<Object?> get props => [email, password];
}

class ResetSignUpView extends SignUpEvent {}