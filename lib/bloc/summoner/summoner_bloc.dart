import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_event.dart';
import 'package:league_of_legends_library/bloc/summoner/summoner_state.dart';
import 'package:league_of_legends_library/core/repository/summoner_repository.dart';

class SummonerBloc extends Bloc<SummonerEvent, SummonerState> {
  final SummonerRepository _summonerRepository;

  SummonerBloc(this._summonerRepository) : super(SummonerLoading()) {
    on<SummonerStarted>(_onStarted);
  }

  Future<void> _onStarted(
      SummonerStarted event, Emitter<SummonerState> emit) async {
    emit(SummonerLoading());
    try {
      final summoner = await _summonerRepository.getSummonerByNameAndTagLine(
          event.name, event.tagLine, event.server);
      final profilePicUri = _summonerRepository
          .getProfileIconUri(summoner.profileIconId.toString());
      emit(SummonerSuccess(summoner, profilePicUri));
    } catch (e) {
      emit(SummonerError(e));
    }
  }
}
