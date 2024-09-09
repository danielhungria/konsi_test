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
  final Cep cep;

  const ResultSelected(this.cep);

  @override
  List<Object> get props => [cep];
}

class ClickSearch extends MapEvent {
  final String query;

  const ClickSearch(this.query);

  @override
  List<Object> get props => [query];
}

class ResetMap extends MapEvent {

  @override
  List<Object> get props => [];
}