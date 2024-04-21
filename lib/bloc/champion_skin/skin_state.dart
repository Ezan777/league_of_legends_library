import 'package:equatable/equatable.dart';

sealed class SkinState extends Equatable {
  const SkinState();

  @override
  List<Object?> get props => [];
}

final class SkinsLoading extends SkinState {}

final class SkinsLoaded extends SkinState {
  final Map<String, int> championIdActiveSkin;

  const SkinsLoaded(this.championIdActiveSkin);

  @override
  List<Object?> get props => [championIdActiveSkin];
}

final class SkinsError extends SkinState {}
