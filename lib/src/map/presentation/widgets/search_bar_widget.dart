import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/res/colours.dart';
import '../bloc/map_bloc.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colours.borderColour,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colours.darkTextColour.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (query) {
          context.read<MapBloc>().add(SearchChanged(query));
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Buscar',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
