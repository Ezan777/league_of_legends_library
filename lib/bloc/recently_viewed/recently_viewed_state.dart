import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';

sealed class RecentlyViewedState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RecentlyViewedLoading extends RecentlyViewedState {}

final class RecentlyViewedLoaded extends RecentlyViewedState {
  final Queue<Champion> recentlyViewedChampions;

  RecentlyViewedLoaded(this.recentlyViewedChampions);

  @override
  List<Object?> get props => [recentlyViewedChampions];
}

final class RecentlyViewedError extends RecentlyViewedState {}
