import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_state.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

final class SetNavigationPage extends NavigationEvent {
  final BodyPages selectedPage;

  const SetNavigationPage(this.selectedPage);

  @override
  List<Object?> get props => [selectedPage];
}
