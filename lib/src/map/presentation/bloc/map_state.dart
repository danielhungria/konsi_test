part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class SearchResults extends MapState {
  final List<String> results;

  const SearchResults(this.results);

  @override
  List<Object> get props => [results];
}

class MapWithMarkers extends MapState {
  final LatLng? selectedLocation;
  final Set<Marker> markers;

  const MapWithMarkers(this.selectedLocation, this.markers);

  @override
  List<Object> get props => [selectedLocation ?? const LatLng(0, 0), markers];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}

class ShowBottomSheetState extends MapState {
  final String cep;
  final String endereco;

  const ShowBottomSheetState(this.cep, this.endereco);

  @override
  List<Object> get props => [cep, endereco];
}
