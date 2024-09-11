import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';
import 'package:konsi_test/src/notebook/domain/repos/notebook_repository.dart';

class AddAddressUsecase implements UsecaseWithParams<void, AddAddressParams> {
  final NotebookRepository repository;

  AddAddressUsecase(this.repository);

  @override
  ResultFuture call(AddAddressParams params) async {
    return await repository.addAddress(params.address);
  }
}

class AddAddressParams {
  final Address address;

  AddAddressParams({required this.address});
}
