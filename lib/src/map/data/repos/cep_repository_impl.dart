import 'package:dartz/dartz.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repos/cep_repository.dart';
import '../datasources/cep_remote_datasource.dart';

class CepRepositoryImpl implements CepRepository {
  final CepRemoteDataSource remoteDataSource;

  CepRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cep>> fetchCep(String cep) async {
    try {
      final result = await remoteDataSource.fetchCep(cep);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } else {
        return Left(ServerFailure(message: 'Unknown error', statusCode: null));
      }
    }
  }
}
