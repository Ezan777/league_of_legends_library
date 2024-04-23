import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

sealed class RecentlyViewedState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RecentlyViewedLoading extends RecentlyViewedState {}

final class RecentlyViewedLoaded extends RecentlyViewedState {
  final Queue<Champion> recentlyViewedChampions;
  final AvailableLanguages? language;

  RecentlyViewedLoaded(this.recentlyViewedChampions, {this.language});

  @override
  List<Object?> get props => [recentlyViewedChampions, language];
}

final class RecentlyViewedError extends RecentlyViewedState {}
