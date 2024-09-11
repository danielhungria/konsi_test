import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';

import '../repos/cep_repository.dart';

class GetHistoryUsecase implements UsecaseWithoutParams {
  final CepRepository repository;

  GetHistoryUsecase(this.repository);

  @override
  ResultFuture call() async {
    return repository.getHistory();
  }

}

