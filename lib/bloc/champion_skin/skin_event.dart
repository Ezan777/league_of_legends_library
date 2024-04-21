import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/core/model/skin.dart';

sealed class SkinsEvent extends Equatable {
  const SkinsEvent();

  @override
  List<Object?> get props => [];
}

final class SkinsStarted extends SkinsEvent {}

final class AddSkinToChampion extends SkinsEvent {
  final Champion champion;
  final Skin skin;

  const AddSkinToChampion(this.champion, this.skin);

  @override
  List<Object?> get props => [champion.id, skin.name];
}
