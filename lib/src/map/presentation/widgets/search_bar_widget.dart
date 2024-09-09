import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/res/colours.dart';
import '../../../../core/utils/core_utils.dart';

class SearchBarWidget extends StatefulWidget {
  final FocusNode focusNode;
  final void Function(String) onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.focusNode,
    required this.onSearchChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      final formattedText = CoreUtils.formatCep(text.replaceAll('-', ''));
      _controller.value = _controller.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
      widget.onSearchChanged(formattedText.replaceAll('-', ''));
    });
  }

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
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(8),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Buscar',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
