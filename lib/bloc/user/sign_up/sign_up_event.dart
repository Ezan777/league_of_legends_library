import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/data/riot_summoner_api.dart';

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
  List<Object?> get props =>
      [email, password, summonerName, tagLine, name, surname, server];
}

class ResetSignUpView extends SignUpEvent {}
