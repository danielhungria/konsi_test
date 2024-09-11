import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/repos/cep_repository.dart';
import 'package:konsi_test/src/map/domain/usecases/get_history.dart';
import 'package:konsi_test/core/errors/failures.dart';

class MockCepRepository extends Mock implements CepRepository {}

void main() {
  late GetHistoryUsecase usecase;
  late MockCepRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCep());
  });

  setUp(() {
    mockRepository = MockCepRepository();
    usecase = GetHistoryUsecase(mockRepository);
  });

  final tHistory = [
    Cep(
      cep: '01001-000',
      bairro: 'Bairro teste',
      logradouro: 'lado ímpar',
      localidade: 'Teste',
      estado: 'BA',
      ddd: '71',
      uf: 'BA',
    )
  ];

  test('should return list of Cep when the call to repository is successful', () async {
    // arrange
    when(() => mockRepository.getHistory()).thenAnswer((_) => Right(tHistory));
    // act
    final result = await usecase();
    // assert
    verify(() => mockRepository.getHistory());
    expect(result, Right(tHistory));
  });

  test('should return CacheFailure when the call to repository is unsuccessful', () async {
    // arrange
    when(() => mockRepository.getHistory())
        .thenAnswer((_) => Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    // act
    final result = await usecase();
    // assert
    verify(() => mockRepository.getHistory());
    expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
  });
}

class FakeCep extends Fake implements Cep {}
