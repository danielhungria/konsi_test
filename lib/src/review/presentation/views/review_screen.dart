import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/core/services/app_router.dart';
import 'package:konsi_test/src/notebook/presentation/bloc/notebook_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../../notebook/domain/entities/address.dart';

class ReviewScreen extends StatefulWidget {
  final String cep;
  final String formattedAddress;

  const ReviewScreen({
    super.key,
    required this.cep,
    required this.formattedAddress,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberController.text = '';
    _complementController.text = '';
  }

  @override
  void dispose() {
    _numberController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.lightTileBackgroundColour,
      appBar: AppBar(
        title: const Text('Revisão'),
        backgroundColor: Colours.lightTileBackgroundColour,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            RouterHelper.goHome(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'CEP',
              initialValue: widget.cep,
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              label: 'Endereço',
              initialValue: widget.formattedAddress,
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              label: 'Número',
              controller: _numberController,
              digitOnly: true,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              label: 'Complemento',
              controller: _complementController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.primaryColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _onConfirm,
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    bool readOnly = false,
    bool digitOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      enableInteractiveSelection: !readOnly,
      inputFormatters: [
        digitOnly ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
      ],
      keyboardType: digitOnly ? TextInputType.number : TextInputType.text,
      focusNode: readOnly ? AlwaysDisabledFocusNode() : null,
      style: TextStyle(
        color: readOnly ? Colours.neutralTextColour : Colours.darkTextColour,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colours.lightTileBackgroundColour,
        labelText: label,
        labelStyle: TextStyle(
          color: readOnly ? Colours.neutralTextColour : Colours.darkTextColour,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: readOnly ? Colours.neutralTextColour : Colours.darkTextColour,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  void _onConfirm() {
    final number = _numberController.text;
    final complement = _complementController.text;
    sl<NotebookBloc>().add(AddAddress(
      Address(
        cep: widget.cep,
        street: widget.formattedAddress,
        number: number,
        complement: complement,
      ),
    ));
    RouterHelper.goHome(context, tab: 1);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
