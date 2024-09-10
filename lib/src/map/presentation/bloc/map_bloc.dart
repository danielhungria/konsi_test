import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/usecases/fetch_cep.dart';

import '../../../../core/services/geocoding_service.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc(this.fetchCepUsecase, this.geocodingService, this.historyBox,) : super(const MapInitial()) {
    on<SearchChanged>(_onSearchChanged);
    on<ResultSelected>(_onResultSelected);
    on<ClickSearch>(_onClickSearch);
    on<ResetMap>(_onResetMap);
    history = List<Cep>.from(historyBox.values);
  }

  final FetchCepUsecase fetchCepUsecase;
  final GeocodingService geocodingService;
  final Box<Cep> historyBox;
  List<Cep> history = [];

  Future<void> _onSearchChanged(
    SearchChanged event,
    Emitter<MapState> emit,
  ) async {
    final filteredHistory = _filterSearchResults(event.query);

    emit(SearchResults(filteredHistory, ''));
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
        final formattedAddress = '${r.logradouro} - ${r.bairro}, ${r.localidade} - ${r.uf}';
        if (!history.any((cep) => cep.cep == r.cep)) {
          history.insert(0, r);
          historyBox.add(r);
        }
        emit(SearchResults(_filterSearchResults(event.query), formattedAddress));
      },
    );
  }

  Future<void> _onResultSelected(
    ResultSelected event,
    Emitter<MapState> emit,
  ) async {
    final latLng = await geocodingService.getLatLngFromCep(event.cep.cep);
    final formattedAddress = '${event.cep.logradouro} - ${event.cep.bairro}, ${event.cep.localidade} - ${event.cep.uf}';
    if (latLng != null) {
      final markers = {
            Marker(
              markerId: const MarkerId('selected_location'),
              position: latLng,
              infoWindow: InfoWindow(title: event.cep.logradouro),
            ),
          };
      final cep = event.cep.cep;

      emit(ShowBottomSheetState(cep, formattedAddress));

      emit(MapWithMarkers(latLng, markers));
    }else{
      emit(const MapError('Erro ao buscar dados do CEP'));
    }
  }

  void _onResetMap(ResetMap event,Emitter<MapState> emit,) async {
    emit(const MapInitial());
  }

  List<Cep> _filterSearchResults(String query) {
    final result = history.where((cep) => cep.cep.replaceAll('-', '').contains(query)).toList();
    return result;
  }

}
