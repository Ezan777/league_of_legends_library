import 'package:equatable/equatable.dart';
import 'package:league_of_legends_library/bloc/settings/theme_bloc/theme_state.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

final class ThemeStarted extends ThemeEvent {}

final class ChangeThemeMode extends ThemeEvent {
  final AppThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
