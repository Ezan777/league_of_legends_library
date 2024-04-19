import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';

sealed class RecentlyViewedEvent extends Equatable {
  const RecentlyViewedEvent();

  @override
  List<Object?> get props => [];
}

final class RecentlyViewedStarted extends RecentlyViewedEvent {}

final class AddChampionToRecentlyViewed extends RecentlyViewedEvent {
  final Champion addedChampion;

  const AddChampionToRecentlyViewed(this.addedChampion);

  @override
  List<Object?> get props => [addedChampion];
}
