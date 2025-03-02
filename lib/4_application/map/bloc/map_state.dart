import 'package:equatable/equatable.dart';

abstract class MapState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {}

class MapLoadWallboxesRequested extends MapState {}

class MapShowWallboxInfoRequested extends MapState {
  final String wallboxId;
  MapShowWallboxInfoRequested(this.wallboxId);
  @override
  List<Object?> get props => [wallboxId];
}

class MapShowWallboxInfo extends MapState {
  final String wallboxId;

  MapShowWallboxInfo(this.wallboxId);

  @override
  List<Object?> get props => [wallboxId];
}
