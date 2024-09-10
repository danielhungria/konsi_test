import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/address.dart';

part 'notebook_event.dart';

part 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  NotebookBloc() : super(NotebookLoading()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<SearchChangedNotebook>(_onSearchChanged);
    on<AddAddress>(_onAddAddress);
  }

  final List<Address> _addresses = [];

  void _onLoadAddresses(
    LoadAddresses event,
    Emitter<NotebookState> emit,
  ) {
    emit(NotebookLoaded(_addresses));
  }

  void _onAddAddress(
    AddAddress event,
    Emitter<NotebookState> emit,
  ) {
    emit(NotebookLoading());
    _addresses.add(event.address);

    emit(NotebookLoaded(List<Address>.from(_addresses)));
  }

  void _onSearchChanged(
    SearchChangedNotebook event,
    Emitter<NotebookState> emit,
  ) {
    if (state is NotebookLoaded) {
      final filteredAddresses = _addresses
          .where((address) => address.cep.contains(event.query) || address.street.contains(event.query))
          .toList();
      emit(NotebookLoaded(filteredAddresses));
      if(event.query.isEmpty) {
        emit(NotebookLoaded(_addresses));
      }
    }
  }
}
