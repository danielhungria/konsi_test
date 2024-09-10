part of 'notebook_bloc.dart';
// lib/src/features/notebook/presentation/bloc/notebook_event.dart

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

