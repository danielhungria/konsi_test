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

class SearchChanged extends NotebookEvent {
  final String query;

  SearchChanged(this.query);

  @override
  List<Object> get props => [query];
}
