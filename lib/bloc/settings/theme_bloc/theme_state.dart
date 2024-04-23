import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode {
  followSystem,
  dark,
  light;

  factory AppThemeMode.fromString(String themeMode) {
    return switch (themeMode) {
      "followSystem" => AppThemeMode.followSystem,
      "dark" => AppThemeMode.dark,
      "light" => AppThemeMode.light,
      _ => throw Exception("Invalid theme mode string"),
    };
  }

  String displayName() => switch (this) {
        AppThemeMode.followSystem => "Use system mode",
        AppThemeMode.dark => "Dark mode",
        AppThemeMode.light => "Light mode",
      };

  ThemeMode toMaterialThemeMode() => switch (this) {
        AppThemeMode.followSystem => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  @override
  String toString() => name;
}

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

final class ThemeLoading extends ThemeState {}

final class ThemeLoaded extends ThemeState {
  final AppThemeMode themeMode;

  const ThemeLoaded(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

final class ThemeError extends ThemeState {}
