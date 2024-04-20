import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_event.dart';
import 'package:league_of_legends_library/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(BodyPages.homepage)) {
    on<SetNavigationPage>(
      (event, emit) => emit(NavigationState(event.selectedPage)),
    );
  }
}
