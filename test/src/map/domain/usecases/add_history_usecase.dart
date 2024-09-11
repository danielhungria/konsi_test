import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/repos/cep_repository.dart';
import 'package:konsi_test/src/map/domain/usecases/add_history.dart';
import 'package:konsi_test/core/errors/failures.dart';

class MockCepRepository extends Mock implements CepRepository {}

void main() {
  late AddHistoryUsecase usecase;
  late MockCepRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCep());
  });

  setUp(() {
    mockRepository = MockCepRepository();
    usecase = AddHistoryUsecase(mockRepository);
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

  final tParams = AddHistoryParams(cep: tCep);

  test('should add Cep to repository and return Right(null) when successful', () async {
    // arrange
    when(() => mockRepository.addCep(any())).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.addCep(tCep));
    expect(result, const Right(null));
  });

  test('should return CacheFailure when adding Cep to repository is unsuccessful', () async {
    // arrange
    when(() => mockRepository.addCep(any()))
        .thenAnswer((_) async => Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.addCep(tCep));
    expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
  });
}

class FakeCep extends Fake implements Cep {}
