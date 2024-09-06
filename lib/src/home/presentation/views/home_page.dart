// lib/src/presentation/home_page.dart

import 'package:flutter/material.dart';
import 'package:konsi_test/core/res/colours.dart';

import '../../../map/presentation/views/map_screen.dart';
import '../../../notebook/presentation/views/notebook_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? const MapScreen() : const NotebookScreen(),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
