import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/core/res/colours.dart';
import '../../../../core/services/injection_container.dart';
import '../bloc/map_bloc.dart';
import '../widgets/cep_bottom_sheet.dart';
import '../widgets/search_bar_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final mapBloc = sl<MapBloc>();
    return BlocProvider(
      create: (_) => mapBloc,
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is ShowBottomSheetState) {
            _showBottomSheet(context, state.cep, state.endereco);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              if (state is MapWithMarkers || state is MapInitial)
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-12.906396, -38.397681),
                    zoom: 12,
                  ),
                  markers: state is MapWithMarkers ? state.markers : {},
                ),
              if (state is SearchResults)
                Positioned.fill(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 130),
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.results.length,
                            itemBuilder: (context, index) {
                              final result = state.results[index];
                              final cep = result.split(' - ')[0];
                              final endereco = result.split(' - ')[1];
                              return ListTile(
                                leading: const Icon(Icons.location_on, color: Colours.primaryColour),
                                title: Text(
                                  cep,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  endereco,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  focusNode.unfocus();
                                  mapBloc.add(ResultSelected(result));
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(color: Colours.borderColour),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 70,
                left: 10,
                right: 10,
                child: SearchBarWidget(
                  focusNode: focusNode,
                  onSearchChanged: (search) {
                    mapBloc.add(SearchChanged(search));
                  },
                ),
              ),
            ],
          );
        },
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
        );
      },
    );
  }
}
