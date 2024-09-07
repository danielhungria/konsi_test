// lib/src/presentation/bloc/navigation_state.dart
part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {
  final int index;

  const NavigationInitial(this.index);

  @override
  List<Object> get props => [index];
}

class NavigationTabChanged extends NavigationState {
  final int index;

  const NavigationTabChanged(this.index);

  @override
  List<Object> get props => [index];
}
