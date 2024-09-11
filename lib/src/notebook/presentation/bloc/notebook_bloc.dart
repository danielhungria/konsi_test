import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/address.dart';
import '../../domain/usecases/add_address.dart';
import '../../domain/usecases/get_addresses.dart';
import '../../domain/usecases/remove_address.dart';

part 'notebook_event.dart';

part 'notebook_state.dart';

class NotebookBloc extends Bloc<NotebookEvent, NotebookState> {
  final AddAddressUsecase addAddressUsecase;
  final GetAddressesUsecase getAddressesUsecase;
  final RemoveAddressUsecase removeAddressUsecase;

  NotebookBloc(
    this.addAddressUsecase,
    this.getAddressesUsecase,
    this.removeAddressUsecase,
  ) : super(NotebookLoading()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<SearchChangedNotebook>(_onSearchChanged);
    on<AddAddress>(_onAddAddress);
    on<RemoveAddress>(_onRemoveAddress);
    _loadAddresses();
  }

  List<Address> _addresses = [];

  Future<void> _loadAddresses() async {
    final result = await getAddressesUsecase.call();
    result.fold(
      (failure) => null,
      (addresses) {
        _addresses = addresses;
      },
    );
  }

  void _onLoadAddresses(
    LoadAddresses event,
    Emitter<NotebookState> emit,
  ) {
    emit(NotebookLoading());
    emit(NotebookLoaded(_addresses));
  }

  void _onAddAddress(
    AddAddress event,
    Emitter<NotebookState> emit,
  ) async {
    emit(NotebookLoading());
    final result = await addAddressUsecase.call(AddAddressParams(address: event.address));
    result.fold(
      (failure) => emit(NotebookLoaded(List<Address>.from(_addresses))),
      (_) {
        _addresses.add(event.address);
        emit(NotebookLoaded(List<Address>.from(_addresses)));
      },
    );
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
      if (event.query.isEmpty) {
        emit(NotebookLoaded(_addresses));
      }
    }
  }

  void _onRemoveAddress(
    RemoveAddress event,
    Emitter<NotebookState> emit,
  ) {
    emit(NotebookLoading());
    _addresses.remove(event.address);
    removeAddressUsecase.call(RemoveAddressParams(address: event.address));
    emit(NotebookLoaded(List<Address>.from(_addresses)));
  }
}
