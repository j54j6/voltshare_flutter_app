import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MapLoadRequested extends MapEvent {}

class MapShowWallboxInfoRequested extends MapEvent {
  final String wallboxId;

  MapShowWallboxInfoRequested(this.wallboxId);

  @override
  List<Object> get props => [wallboxId];
}
