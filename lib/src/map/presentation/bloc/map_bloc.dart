import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapInitial()) {
    on<SearchChanged>(_onSearchChanged);
    on<ResultSelected>(_onResultSelected);
  }

  void _onSearchChanged(
    SearchChanged event,
    Emitter<MapState> emit,
  ) {
    final results = _filterSearchResults(event.query);
    emit(SearchResults(results));
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
    final endereco = event.address.split(' - ')[1];

    emit(ShowBottomSheetState(cep, endereco));

    emit(MapWithMarkers(position, markers));
  }

  List<String> _mockSearchResults() {
    return [
      '12345-678 - Rua Exemplo, Beairro A',
      '23456-789 - Rua Teste, Bairro B',
      '34567-890 - Rua Fictícia, Bairro C'
    ];
  }

  List<String> _filterSearchResults(String query) {
    return _mockSearchResults().where((result) => result.contains(query)).toList();
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
