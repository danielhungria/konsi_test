import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/usecases/fetch_cep.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(this.fetchCepUsecase) : super(const MapInitial()) {
    on<SearchChanged>(_onSearchChanged);
    on<ResultSelected>(_onResultSelected);
    on<ClickSearch>(_onClickSearch);
    on<ResetMap>(_onResetMap);
  }

  final FetchCepUsecase fetchCepUsecase;
  List<Cep> history = [];

  Future<void> _onSearchChanged(
    SearchChanged event,
    Emitter<MapState> emit,
  ) async {
    final filteredHistory = _filterSearchResults(event.query);

    emit(SearchResults(filteredHistory));
  }

  Future<void> _onClickSearch(
    ClickSearch event,
    Emitter<MapState> emit,
  ) async {
    FetchCepParams params = FetchCepParams(cep: event.query);

    final result = await fetchCepUsecase.call(params);

    result.fold(
      (l) => emit(SearchResultError(l.errorMessage)),
      (r) {
        if (!history.any((cep) => cep.cep == r.cep)) {
          history.insert(0, r);
        }
        emit(SearchResults(_filterSearchResults(event.query)));
      },
    );
  }

  void _onResultSelected(
    ResultSelected event,
    Emitter<MapState> emit,
  ) {
    final position = _getLatLngForAddress(event.address);
    final markers = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        infoWindow: InfoWindow(title: event.address),
      ),
    };
    final cep = event.address.split(' - ')[0];
    final address = event.address.split(' - ')[1];

    emit(ShowBottomSheetState(cep, address));

    emit(MapWithMarkers(position, markers));
  }

  void _onResetMap(ResetMap event,Emitter<MapState> emit,) async {
    emit(const MapInitial());
  }

  List<Cep> _filterSearchResults(String query) {
    final result = history.where((cep) => cep.cep.replaceAll('-', '').contains(query)).toList();
    return result;
  }

  LatLng _getLatLngForAddress(String address) {
    switch (address) {
      case '12345-678 - Rua Exemplo, Bairro A':
        return const LatLng(-12.906396, -38.397681);
      case '23456-789 - Rua Teste, Bairro B':
        return const LatLng(-12.900000, -38.400000);
      case '34567-890 - Rua Fictícia, Bairro C':
        return const LatLng(-12.910000, -38.405000);
      default:
        return const LatLng(-12.906396, -38.397681);
    }
  }
}
