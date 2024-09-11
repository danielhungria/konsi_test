import '../../../../core/utils/typdefs.dart';
import '../entities/cep.dart';

abstract class CepRepository {
  ResultFuture<Cep> fetchCep(String cep);

  Result<List<Cep>> getHistory();

  ResultFuture addCep(Cep cep);
}
