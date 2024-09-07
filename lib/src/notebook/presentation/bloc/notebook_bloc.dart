import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/address.dart';

part 'notebook_event.dart';

part 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  NotebookBloc() : super(NotebookLoading()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<SearchChanged>(_onSearchChanged);
  }

  void _onLoadAddresses(
    LoadAddresses event,
    Emitter<NotebookState> emit,
  ) {
    // Mocking some addresses
    final addresses = List.generate(
      10,
      (index) => Address(
        cep: '12345-$index',
        street: 'Street $index',
      ),
    );
    emit(NotebookLoaded(addresses));
  }

  void _onSearchChanged(
    SearchChanged event,
    Emitter<NotebookState> emit,
  ) {
    if (state is NotebookLoaded) {
      final currentState = state as NotebookLoaded;
      final filteredAddresses = currentState.addresses
          .where((address) => address.cep.contains(event.query) || address.street.contains(event.query))
          .toList();
      emit(NotebookLoaded(filteredAddresses));
    }
  }
}
