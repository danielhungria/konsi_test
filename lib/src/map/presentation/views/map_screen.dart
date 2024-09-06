import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:konsi_test/core/res/colours.dart';
import '../bloc/map_bloc.dart';
import '../widgets/search_bar_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc(),
      child: BlocBuilder<MapBloc, MapState>(
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
                                leading: const Icon(Icons.location_on, color: Colors.blue),
                                title: Text(
                                  cep,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  endereco,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  context.read<MapBloc>().add(ResultSelected(result));
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
              const Positioned(
                top: 70,
                left: 10,
                right: 10,
                child: SearchBarWidget(),
              ),
            ],
          );
        },
      ),
    );
  }
}