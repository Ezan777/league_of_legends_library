import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_event.dart';
import 'package:league_of_legends_library/bloc/champion_skin/skin_state.dart';
import 'package:league_of_legends_library/core/repository/champion_repository.dart';

class SkinsBloc extends Bloc<SkinsEvent, SkinState> {
  final ChampionRepository championRepository;

  SkinsBloc({required this.championRepository}) : super(SkinsLoading()) {
    on<SkinsStarted>(_onStarted);
    on<AddSkinToChampion>(_onSkinAdded);
  }

  Future<void> _onStarted(SkinsEvent event, Emitter<SkinState> emit) async {
    emit(SkinsLoading());
    try {
      final championIdActiveSkin =
          Map.of(championRepository.championIdActiveSkin);
      emit(SkinsLoaded(championIdActiveSkin));
    } catch (_) {
      emit(SkinsError());
    }
  }

  Future<void> _onSkinAdded(
      AddSkinToChampion event, Emitter<SkinState> emit) async {
    final state = this.state;
    if (state is SkinsLoaded) {
      try {
        if (await championRepository.addChampionSkin(
            event.champion, event.skin)) {
          final Map<String, int> newMap = Map.of(state.championIdActiveSkin);
          newMap[event.champion.id] = event.skin.skinCode;
          emit(SkinsLoaded(newMap));
        } else {
          emit(SkinsError());
        }
      } catch (_) {
        emit(SkinsError());
      }
    }
  }
}
