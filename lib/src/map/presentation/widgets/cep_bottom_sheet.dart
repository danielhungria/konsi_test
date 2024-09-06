import 'package:flutter/material.dart';
import 'package:konsi_test/core/res/colours.dart';

class CepBottomSheet extends StatelessWidget {
  final String cep;
  final String address;

  const CepBottomSheet({
    super.key,
    required this.cep,
    required this.address,
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
                },
                child: const Text('Salvar Endereço', style: TextStyle(color: Colours.lightTileBackgroundColour),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
