import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/repos/cep_repository.dart';
import 'package:konsi_test/src/map/domain/usecases/fetch_cep.dart';
import 'package:konsi_test/core/errors/failures.dart';

class MockCepRepository extends Mock implements CepRepository {}

void main() {
  late FetchCepUsecase usecase;
  late MockCepRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCep());
  });

  setUp(() {
    mockRepository = MockCepRepository();
    usecase = FetchCepUsecase(mockRepository);
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

  final tParams = FetchCepParams(cep: '01001-000');

  test('should return Cep when the call to repository is successful', () async {
    // arrange
    when(() => mockRepository.fetchCep(any())).thenAnswer((_) async => Right(tCep));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.fetchCep(tParams.cep));
    expect(result, Right(tCep));
  });

  test('should return ServerFailure when the call to repository is unsuccessful', () async {
    // arrange
    when(() => mockRepository.fetchCep(any()))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Server Error', statusCode: 500)));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.fetchCep(tParams.cep));
    expect(result, Left(ServerFailure(message: 'Server Error', statusCode: 500)));
  });
}

class FakeCep extends Fake implements Cep {}
