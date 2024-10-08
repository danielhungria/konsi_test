import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/core/res/media_res.dart';
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
              children: const [
                MapScreen(),
                NotebookScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colours.lightTileBackgroundColour,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    MediaRes.mapIcon,
                    color: selectedIndex == 0 ? Colours.primaryColour : Colours.neutralTextColour,
                  ),
                  label: 'Mapa',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    MediaRes.notebookIcon,
                    color: selectedIndex == 1 ? Colours.primaryColour : Colours.neutralTextColour,
                  ),
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
