import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/src/notebook/presentation/bloc/notebook_bloc.dart';

class CepBottomSheet extends StatelessWidget {
  final String cep;
  final String address;
  final NotebookBloc notebookBloc;

  const CepBottomSheet({
    super.key,
    required this.cep,
    required this.address,
    required this.notebookBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cep,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              address,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.primaryColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.go(
                    '/review',
                    extra: {
                      'cep': cep,
                      'address': address,
                      'notebookBloc': notebookBloc,
                    },
                  );
                },
                child: const Text(
                  'Salvar Endereço',
                  style: TextStyle(color: Colours.lightTileBackgroundColour),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
