import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitial(0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(NavigationTabChanged(event.index));
    });
  }
}
