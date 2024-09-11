import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/core/extensions/context_extension.dart';
import 'package:konsi_test/core/extensions/custom_size_extension.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/core/utils/core_utils.dart';

import '../../../../core/services/injection_container.dart';
import '../bloc/map_bloc.dart';
import '../widgets/cep_bottom_sheet.dart';
import '../widgets/search_bar_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapBloc _mapBloc;
  GoogleMapController? _mapController;
  FocusNode focusNode = FocusNode();
  String cepNumber = '';
  bool hasFocusSearchBar = false;

  @override
  void initState() {
    _mapBloc = sl<MapBloc>();
    focusNode.addListener(() {
      setState(() {
        hasFocusSearchBar = focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is ShowBottomSheetState) {
            _showBottomSheet(context, state.cep, state.formattedAddress);
          }
          if (state is MapError) {
            CoreUtils.showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              if (state is MapWithMarkers || state is MapInitial) _buildMap(state),
              if (state is SearchResults || state is SearchResultError || state is MapError)
                _buildSearchResultsOrError(state),
              Positioned(
                top: 70,
                left: 10,
                right: 10,
                child: SearchBarWidget(
                  focusNode: focusNode,
                  onSearchChanged: (search) {
                    _mapBloc.add(SearchChanged(search));
                    cepNumber = search;
                  },
                  onTapOutside: () {
                    focusNode.unfocus();
                  },
                  onSubmitted: () {
                    focusNode.unfocus();
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
      onTap: (position) {
        focusNode.unfocus();
        _mapBloc.add(MapTap(position));
      },
    );
  }

  Widget _buildSearchResultsOrError(MapState state) {
    final message = state is SearchResultError
        ? state.message
        : state is MapError
            ? state.message
            : '';
    return Positioned.fill(
      child: Scaffold(
        backgroundColor: Colours.lightTileBackgroundColour,
        body: Column(
          children: [
            (context.height * 0.09).h,
            if (state is SearchResultError || state is MapError)
              _buildErrorWidget(message)
            else if (state is SearchResults)
              _buildSearchResultsList(state)
          ],
        ),
        floatingActionButton: hasFocusSearchBar
            ? FloatingActionButton(
                backgroundColor: Colours.primaryColour,
                onPressed: () {
                  focusNode.unfocus();
                  if (cepNumber.isNotEmpty && cepNumber.length == 8) {
                    _mapBloc.add(ClickSearch(cepNumber));
                  } else {
                    CoreUtils.showSnackBar(context, 'INVALID CEP');
                  }
                },
                child: const Icon(Icons.search),
              )
            : null,
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 80,
            ),
            20.h,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'O CEP informado é inválido:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            10.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
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
          final formattedAddress = '${result.logradouro} - ${result.bairro}, ${result.localidade} - ${result.uf}';
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colours.primaryColour),
            title: Text(
              cep,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              formattedAddress,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              focusNode.unfocus();
              _mapBloc.add(ResultSelected(result));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(color: Colours.borderColour),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String cep, String formattedAddress) {
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
          formattedAddress: formattedAddress,
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
