import 'package:equatable/equatable.dart';

enum BodyPages {
  homepage,
  championPage,
  settings,
}

final class NavigationState extends Equatable {
  final BodyPages selectedPage;

  const NavigationState(this.selectedPage);

  @override
  List<Object?> get props => [selectedPage];
}
