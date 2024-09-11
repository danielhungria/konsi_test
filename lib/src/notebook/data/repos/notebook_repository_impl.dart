import 'package:dartz/dartz.dart';
import 'package:konsi_test/core/utils/typdefs.dart';
import 'package:konsi_test/src/notebook/data/datasources/notebook_local_datasource.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repos/notebook_repository.dart';

class NotebookRepositoryImpl implements NotebookRepository {
  final NotebookLocalDataSource localDataSource;

  NotebookRepositoryImpl({
    required this.localDataSource,
  });

  @override
  ResultFuture addAddress(Address address) async {
    try {
      await localDataSource.addAddress(address);
      return const Right(null);
    } catch (e) {
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
      } else {
        return Left(CacheFailure(message: 'Erro ao salvar o endereço localmente', statusCode: 500));
      }
    }
  }

  @override
  Result<List<Address>> getAddresses() {
    try {
      final addresses = localDataSource.getAddresses();
      return Right(addresses);
    } catch (e) {
      return Left(CacheFailure(message: 'Erro ao buscar endereços', statusCode: 500));
    }
  }

  @override
  ResultFuture removeAddress(Address address) async {
    try {
      localDataSource.deleteAddress(address);
      return const Right(null);
    } catch (e) {
      if (e is CacheException) {
        return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
      } else {
        return Left(CacheFailure(message: 'Erro ao remover o endereço localmente', statusCode: 500));
      }
    }
  }

}
