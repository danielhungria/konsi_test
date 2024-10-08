import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsi_test/core/res/colours.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';

import '../../../../core/services/injection_container.dart';
import '../../../map/presentation/widgets/search_bar_widget.dart';
import '../bloc/notebook_bloc.dart';

class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  @override
  void initState() {
    super.initState();
    sl<NotebookBloc>().add(LoadAddresses());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotebookBloc>(),
      child: Scaffold(
        backgroundColor: Colours.lightTileBackgroundColour,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0, left: 10, right: 10),
              child: SearchBarWidget(
                focusNode: FocusNode(),
                onSearchChanged: (query) {
                  sl<NotebookBloc>().add(SearchChangedNotebook(query));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<NotebookBloc, NotebookState>(
                builder: (context, state) {
                  if (state is NotebookLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotebookLoaded) {
                    if (state.addresses.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 80,
                              color: Colours.primaryColour,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Nenhum endereço salvo.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colours.darkTextColour,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: state.addresses.length,
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          final formattedAddress = '${address.street}, ${address.number} - ${address.complement}';
                          return ListTile(
                            title: Text(
                              address.cep,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              formattedAddress,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colours.softBackgroundColour),
                              ),
                              icon: const Icon(
                                Icons.bookmark,
                                color: Colours.primaryColour,
                              ),
                              onPressed: () {
                                sl<NotebookBloc>().add(RemoveAddress(address));
                              },
                            ),
                            onTap: () {
                              _showAddressDetailsDialog(context, address);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(color: Colours.borderColour),
                      );
                    }
                  } else if (state is NotebookError) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 80,
                            color: Colours.primaryColour,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Erro ao carregar endereços.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colours.darkTextColour,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressDetailsDialog(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalhes do Endereço'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CEP: ${address.cep}'),
              Text('Rua: ${address.street}'),
              Text('Número: ${address.number}'),
              Text('Complemento: ${address.complement}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

}
