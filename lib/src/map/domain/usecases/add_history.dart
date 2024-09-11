import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';

import '../entities/cep.dart';
import '../repos/cep_repository.dart';

class AddHistoryUsecase implements UsecaseWithParams<void, AddHistoryParams> {
  final CepRepository repository;

  AddHistoryUsecase(this.repository);

  @override
  ResultFuture call(AddHistoryParams params) async {
    return await repository.addCep(params.cep);
  }
}

class AddHistoryParams {
  final Cep cep;

  AddHistoryParams({required this.cep});
}
