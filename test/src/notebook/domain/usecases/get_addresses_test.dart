import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_test/core/errors/failures.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';
import 'package:konsi_test/src/notebook/domain/repos/notebook_repository.dart';
import 'package:konsi_test/src/notebook/domain/usecases/get_addresses.dart';
import 'package:mocktail/mocktail.dart';

class MockAddressRepository extends Mock implements NotebookRepository {}

void main() {
  late GetAddressesUsecase usecase;
  late MockAddressRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeAddress());
  });

  setUp(() {
    mockRepository = MockAddressRepository();
    usecase = GetAddressesUsecase(mockRepository);
  });

  final tAddress = [
    Address(
      cep: '01001-000',
      street: 'Bairro teste',
      number: 'lado ímpar',
      complement: '',
    )
  ];

  test('should return list of Cep when the call to repository is successful', () async {
    // arrange
    when(() => mockRepository.getAddresses()).thenAnswer((_) => Right(tAddress));
    // act
    final result = await usecase();
    // assert
    verify(() => mockRepository.getAddresses());
    expect(result, Right(tAddress));
  });

  test('should return CacheFailure when the call to repository is unsuccessful', () async {
    // arrange
    when(() => mockRepository.getAddresses())
        .thenAnswer((_) => Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
    // act
    final result = await usecase();
    // assert
    verify(() => mockRepository.getAddresses());
    expect(result, Left(CacheFailure(message: 'Cache Error', statusCode: 500)));
  });
}

class FakeAddress extends Fake implements Address {}
