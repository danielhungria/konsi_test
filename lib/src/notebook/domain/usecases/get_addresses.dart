import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';
import 'package:konsi_test/src/notebook/domain/repos/notebook_repository.dart';


class GetAddressesUsecase implements UsecaseWithoutParams {
  final NotebookRepository repository;

  GetAddressesUsecase(this.repository);

  @override
  ResultFuture call() async {
    return repository.getAddresses();
  }

}

