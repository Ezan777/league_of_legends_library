import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/core/model/champion.dart';
import 'package:league_of_legends_library/view/settings/language_settings/available_languages.dart';

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

final class ChangedLanguage extends RecentlyViewedEvent {
  final AvailableLanguages newLanguage;

  const ChangedLanguage(this.newLanguage);

  @override
  List<Object?> get props => [newLanguage];
}
