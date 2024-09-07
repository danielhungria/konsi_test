import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/res/colours.dart';

class SearchBarWidget extends StatelessWidget {
  final FocusNode focusNode;
  final void Function(String) onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.focusNode,
    required this.onSearchChanged,
  });

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
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onSearchChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Buscar',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
