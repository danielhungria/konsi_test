part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class SearchChanged extends MapEvent {
  final String query;

  const SearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

class ResultSelected extends MapEvent {
  final String address;

  const ResultSelected(this.address);

  @override
  List<Object> get props => [address];
}
