import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_test/core/errors/failures.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';
import 'package:konsi_test/src/notebook/domain/repos/notebook_repository.dart';
import 'package:konsi_test/src/notebook/domain/usecases/add_address.dart';
import 'package:konsi_test/src/notebook/domain/usecases/remove_address.dart';
import 'package:mocktail/mocktail.dart';

class MockAddressRepository extends Mock implements NotebookRepository {}

void main() {
  late RemoveAddressUsecase usecase;
  late MockAddressRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeAddress());
  });

  setUp(() {
    mockRepository = MockAddressRepository();
    usecase = RemoveAddressUsecase(mockRepository);
  });

  final tAddress = Address(
    cep: '01001-000',
    street: 'Bairro teste',
    number: 'lado ímpar',
    complement: '',
  );

  final tParams = RemoveAddressParams(address: tAddress);

  test('should add Cep to repository and return Right(null) when successful', () async {
    // arrange
    when(() => mockRepository.removeAddress(any())).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.removeAddress(tAddress));
    expect(result, const Right(null));
  });

  test('should return CacheFailure when adding Cep to repository is unsuccessful', () async {
    // arrange
    when(() => mockRepository.removeAddress(any()))
        .thenAnswer((_) async => Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    // act
    final result = await usecase(tParams);
    // assert
    verify(() => mockRepository.removeAddress(tAddress));
    expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
  });
}

class FakeAddress extends Fake implements Address {}
