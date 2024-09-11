import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_test/core/errors/exceptions.dart';
import 'package:konsi_test/core/errors/failures.dart';
import 'package:konsi_test/src/map/data/datasources/cep_local_datasource.dart';
import 'package:konsi_test/src/map/data/datasources/cep_remote_datasource.dart';
import 'package:konsi_test/src/map/data/models/cep_model.dart';
import 'package:konsi_test/src/map/data/repos/cep_repository_impl.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:mocktail/mocktail.dart';

class MockCepRemoteDataSource extends Mock implements CepRemoteDataSource {}

class MockCepLocalDataSource extends Mock implements CepLocalDataSource {}

class FakeCep extends Fake implements Cep {}

void main() {
  late CepRepositoryImpl repository;
  late MockCepRemoteDataSource mockRemoteDataSource;
  late MockCepLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeCep());
  });

  setUp(() {
    mockRemoteDataSource = MockCepRemoteDataSource();
    mockLocalDataSource = MockCepLocalDataSource();
    repository = CepRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tCep = Cep(
    cep: '01001-000',
    bairro: 'Bairro teste',
    logradouro: 'lado ímpar',
    localidade: 'Teste',
    estado: 'BA',
    ddd: '71',
    uf: 'BA',
  );

  final tCepModel = CepModel(
    cep: '01001-000',
    bairro: 'Bairro teste',
    logradouro: 'lado ímpar',
    localidade: 'Teste',
    estado: 'BA',
    ddd: '71',
    uf: 'BA',
  );

  group('fetchCep', () {
    const tCepString = '01001-000';

    test('should return Cep when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.fetchCep(any())).thenAnswer((_) async => Future.value(tCepModel));
      // act
      final result = await repository.fetchCep(tCepString);
      // assert
      verify(() => mockRemoteDataSource.fetchCep(tCepString));
      expect(result, Right(tCepModel));
    });

    test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockRemoteDataSource.fetchCep(any()))
          .thenThrow(const ServerException(message: 'Server Error', statusCode: '500'));
      // act
      final result = await repository.fetchCep(tCepString);
      // assert
      verify(() => mockRemoteDataSource.fetchCep(tCepString));
      expect(result, Left(ServerFailure(message: 'Server Error', statusCode: '500')));
    });
  });

  group('addCep', () {
    test('should return null when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.addCep(any())).thenAnswer((_) async => 1);
      // act
      final result = await repository.addCep(tCep);
      // assert
      verify(() => mockLocalDataSource.addCep(tCep));
      expect(result, const Right(null));
    });

    test('should return CacheFailure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.addCep(any()))
          .thenThrow(const CacheException(message: 'Cache Error', statusCode: 500));
      // act
      final result = await repository.addCep(tCep);
      // assert
      verify(() => mockLocalDataSource.addCep(tCep));
      expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    });
  });

  group('getHistory', () {
    final tHistory = [tCep];

    test('should return list of Cep when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getHistory()).thenReturn(tHistory);
      // act
      final result = repository.getHistory();
      // assert
      verify(() => mockLocalDataSource.getHistory());
      expect(result, Right(tHistory));
    });

    test('should return CacheFailure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.getHistory())
          .thenThrow(const CacheException(message: 'Cache Error', statusCode: 500));
      // act
      final result = repository.getHistory();
      // assert
      verify(() => mockLocalDataSource.getHistory());
      expect(result, Left(CacheFailure(message: 'Erro ao buscar histórico de CEPs', statusCode: 500)));
    });
  });
}
