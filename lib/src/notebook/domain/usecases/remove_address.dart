import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';
import 'package:konsi_test/src/notebook/domain/repos/notebook_repository.dart';

import '../entities/address.dart';

class RemoveAddressUsecase implements UsecaseWithParams<void, RemoveAddressParams> {
  final NotebookRepository repository;

  RemoveAddressUsecase(this.repository);

  @override
  ResultFuture call(RemoveAddressParams params) async {
    return await repository.removeAddress(params.address);
  }
}

class RemoveAddressParams {
  final Address address;

  RemoveAddressParams({required this.address});
}
