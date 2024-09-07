part of 'notebook_bloc.dart';

// lib/src/features/notebook/presentation/bloc/notebook_state.dart

abstract class NotebookState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotebookLoading extends NotebookState {
  @override
  List<Object> get props => [];
}

class NotebookLoaded extends NotebookState {
  final List<Address> addresses;

  NotebookLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class NotebookError extends NotebookState {
  final String message;

  NotebookError(this.message);

  @override
  List<Object> get props => [message];
}
