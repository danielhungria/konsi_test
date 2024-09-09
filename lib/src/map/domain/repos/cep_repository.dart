import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cep.dart';

abstract class CepRepository {
  Future<Either<Failure, Cep>> fetchCep(String cep);
}
