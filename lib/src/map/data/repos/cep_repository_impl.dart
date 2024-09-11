import 'package:dartz/dartz.dart';
import 'package:konsi_test/core/utils/typdefs.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repos/cep_repository.dart';
import '../datasources/cep_local_datasource.dart';
import '../datasources/cep_remote_datasource.dart';

class CepRepositoryImpl implements CepRepository {
  final CepRemoteDataSource remoteDataSource;
  final CepLocalDataSource localDataSource;

  CepRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  ResultFuture<Cep> fetchCep(String cep) async {
    try {
      final result = await remoteDataSource.fetchCep(cep);
      return Right(result);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } else {
        return Left(ServerFailure(message: 'Erro desconhecido', statusCode: 500));
      }
    }
  }

  @override
  ResultFuture addCep(Cep cep) async {
    try {
      await localDataSource.addCep(cep);
      return const Right(null);
    } catch (e) {
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message, statusCode: 500));
      } else {
        return Left(CacheFailure(message: 'Erro ao salvar o CEP localmente', statusCode: 500));
      }
    }
  }

  @override
  Result<List<Cep>> getHistory() {
    try {
      final history = localDataSource.getHistory();
      return Right(history);
    } catch (e) {
      return Left(CacheFailure(message: 'Erro ao buscar histórico de CEPs', statusCode: 500));
    }
  }
}
