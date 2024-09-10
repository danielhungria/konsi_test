import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/core/utils/core_utils.dart';

import '../../../notebook/presentation/bloc/notebook_bloc.dart';
import '../bloc/map_bloc.dart';
import '../widgets/cep_bottom_sheet.dart';
import '../widgets/search_bar_widget.dart';

class MapScreen extends StatefulWidget {
  final MapBloc mapBloc;
  final NotebookBloc notebookBloc;

  const MapScreen({
    super.key,
    required this.mapBloc,
    required this.notebookBloc,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  FocusNode focusNode = FocusNode();
  String cepNumber = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.mapBloc,
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is ShowBottomSheetState) {
            _showBottomSheet(context, state.cep, state.endereco);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              if (state is MapWithMarkers || state is MapInitial) _buildMap(state),
              if (state is SearchResults || state is SearchResultError)
                _buildSearchResultsOrError(state, widget.mapBloc),
              Positioned(
                top: 70,
                left: 10,
                right: 10,
                child: SearchBarWidget(
                  focusNode: focusNode,
                  onSearchChanged: (search) {
                    widget.mapBloc.add(SearchChanged(search));
                    cepNumber = search;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(MapState state) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-12.906396, -38.397681),
        zoom: 12,
      ),
      markers: state is MapWithMarkers ? state.markers : {},
      onMapCreated: (controller) {
        _mapController = controller;
        if (state is MapWithMarkers) {
          _moveCameraToMarker(state);
        }
      },
    );
  }

  Widget _buildSearchResultsOrError(MapState state, MapBloc mapBloc) {
    return Positioned.fill(
      child: Scaffold(
        backgroundColor: Colours.lightTileBackgroundColour,
        body: Column(
          children: [
            const SizedBox(height: 130),
            if (state is SearchResultError)
              _buildErrorWidget(state)
            else if (state is SearchResults)
              _buildSearchResultsList(state)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colours.primaryColour,
          onPressed: () {
            focusNode.unfocus();
            if (cepNumber.isNotEmpty && cepNumber.length == 8) {
              mapBloc.add(ClickSearch(cepNumber));
            } else {
              CoreUtils.showSnackBar(context, 'INVALID CEP');
            }
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(SearchResultError state) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'INVALID CEP: ${state.message}',
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList(SearchResults state) {
    return Expanded(
      child: ListView.separated(
        itemCount: state.cep.length,
        itemBuilder: (context, index) {
          final result = state.cep[index];
          final cep = result.cep;
          final address = result.bairro;
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colours.primaryColour),
            title: Text(
              cep,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              address,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              focusNode.unfocus();
              widget.mapBloc.add(ResultSelected(result));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(color: Colours.borderColour),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String cep, String address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colours.lightTileBackgroundColour,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      showDragHandle: true,
      builder: (BuildContext context) {
        return CepBottomSheet(
          cep: cep,
          address: address,
          notebookBloc: widget.notebookBloc,
        );
      },
    );
  }

  void _moveCameraToMarker(MapWithMarkers state) {
    if (state.markers.isNotEmpty && _mapController != null) {
      final Marker marker = state.markers.first;
      final LatLng markerPosition = marker.position;

      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(markerPosition, 16),
      );
    }
  }
}
