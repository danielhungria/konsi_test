import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/notebook/data/datasources/notebook_local_datasource.dart';
import 'package:konsi_test/src/notebook/data/repos/notebook_repository_impl.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';
import 'package:konsi_test/core/errors/exceptions.dart';
import 'package:konsi_test/core/errors/failures.dart';

class MockNotebookLocalDataSource extends Mock implements NotebookLocalDataSource {}

class FakeAddress extends Fake implements Address {}

void main() {
  late NotebookRepositoryImpl repository;
  late MockNotebookLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeAddress());
  });

  setUp(() {
    mockLocalDataSource = MockNotebookLocalDataSource();
    repository = NotebookRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tAddress = Address(
    cep: '01001-000',
    complement: 'Complemento',
    number: '123',
    street: 'Rua Teste',
  );

  group('addAddress', () {
    test('should return Right(null) when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.addAddress(any())).thenAnswer((_) async => Future.value());
      // act
      final result = await repository.addAddress(tAddress);
      // assert
      verify(() => mockLocalDataSource.addAddress(tAddress));
      expect(result, const Right(null));
    });

    test('should return CacheFailure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.addAddress(any()))
          .thenThrow(const CacheException(message: 'Cache Error', statusCode: 500));
      // act
      final result = await repository.addAddress(tAddress);
      // assert
      verify(() => mockLocalDataSource.addAddress(tAddress));
      expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    });
  });

  group('getAddresses', () {
    final tAddresses = [tAddress];

    test('should return list of addresses when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getAddresses()).thenReturn(tAddresses);
      // act
      final result = repository.getAddresses();
      // assert
      verify(() => mockLocalDataSource.getAddresses());
      expect(result, Right(tAddresses));
    });

    test('should return CacheFailure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.getAddresses())
          .thenThrow(const CacheException(message: 'Cache Error', statusCode: 500));
      // act
      final result = repository.getAddresses();
      // assert
      verify(() => mockLocalDataSource.getAddresses());
      expect(result, Left(CacheFailure(message: 'Erro ao buscar endereços', statusCode: 500)));
    });
  });

  group('removeAddress', () {
    test('should return Right(null) when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.deleteAddress(any())).thenAnswer((_) async => Future.value());
      // act
      final result = await repository.removeAddress(tAddress);
      // assert
      verify(() => mockLocalDataSource.deleteAddress(tAddress));
      expect(result, const Right(null));
    });

    test('should return CacheFailure when the call to local data source is unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.deleteAddress(any()))
          .thenThrow(const CacheException(message: 'Cache Error', statusCode: 500));
      // act
      final result = await repository.removeAddress(tAddress);
      // assert
      verify(() => mockLocalDataSource.deleteAddress(tAddress));
      expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    });
  });
}
