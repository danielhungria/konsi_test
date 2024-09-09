import 'package:konsi_test/core/usecases/usecases.dart';
import 'package:konsi_test/core/utils/typdefs.dart';

import '../entities/cep.dart';
import '../repos/cep_repository.dart';

class FetchCepUsecase implements UsecaseWithParams<Cep, FetchCepParams> {
  final CepRepository repository;

  FetchCepUsecase(this.repository);

  @override
  ResultFuture<Cep> call(FetchCepParams params) async {
    return await repository.fetchCep(params.cep);
  }
}

class FetchCepParams {
  final String cep;

  FetchCepParams({required this.cep});
}
