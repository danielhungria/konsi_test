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
  final List<Cep> cep;
  final String formattedAddress;

  const SearchResults(this.cep, this.formattedAddress);

  @override
  List<Object> get props => [cep];
}

class SearchResultError extends MapState {
  final String message;

  const SearchResultError(this.message);

  @override
  List<Object> get props => [message];
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
  final String formattedAddress;

  const ShowBottomSheetState(this.cep, this.formattedAddress);

  @override
  List<Object> get props => [cep, formattedAddress];
}
