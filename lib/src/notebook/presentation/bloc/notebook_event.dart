part of 'notebook_bloc.dart';

abstract class NotebookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAddresses extends NotebookEvent {

  @override
  List<Object> get props => [];
}

class SearchChangedNotebook extends NotebookEvent {
  final String query;

  SearchChangedNotebook(this.query);

  @override
  List<Object> get props => [query];
}

class AddAddress extends NotebookEvent {
  final Address address;

  AddAddress(this.address);

  @override
  List<Object> get props => [address];
}

class RemoveAddress extends NotebookEvent {
  final Address address;

  RemoveAddress(this.address);

  @override
  List<Object> get props => [address];
}

