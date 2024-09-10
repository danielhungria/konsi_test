import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/src/map/presentation/bloc/map_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../../map/presentation/views/map_screen.dart';
import '../../../notebook/presentation/bloc/notebook_bloc.dart';
import '../../../notebook/presentation/views/notebook_screen.dart';
import '../bloc/navigation_bloc.dart';

class HomePage extends StatefulWidget {
  final int initialTab;

  const HomePage({super.key, required this.initialTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final navigationBloc = sl<NavigationBloc>();
  final notebookBloc = sl<NotebookBloc>();
  final mapBloc = sl<MapBloc>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => navigationBloc..add(ChangeTabEvent(widget.initialTab)),
        ),
        BlocProvider(
          create: (context) => notebookBloc,
        ),
        BlocProvider(
          create: (context) => mapBloc,
        ),
      ],
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final selectedIndex = state is NavigationTabChanged ? state.index : widget.initialTab;

          return Scaffold(
            body: IndexedStack(
              index: selectedIndex,
              children: [
                MapScreen(mapBloc: mapBloc, notebookBloc: notebookBloc),
                NotebookScreen(notebookBloc: notebookBloc),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colours.lightTileBackgroundColour,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Mapa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Caderneta',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (index) {
                navigationBloc.add(ChangeTabEvent(index));
                mapBloc.add(ResetMap());
              },
            ),
          );
        },
      ),
    );
  }
}
