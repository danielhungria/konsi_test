import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/notebook/domain/entities/address.dart';
import 'package:konsi_test/src/notebook/domain/usecases/add_address.dart';
import 'package:konsi_test/src/notebook/domain/usecases/get_addresses.dart';
import 'package:konsi_test/src/notebook/domain/usecases/remove_address.dart';
import 'package:konsi_test/src/notebook/presentation/bloc/notebook_bloc.dart';

class MockAddAddressUsecase extends Mock implements AddAddressUsecase {}
class MockGetAddressesUsecase extends Mock implements GetAddressesUsecase {}
class MockRemoveAddressUsecase extends Mock implements RemoveAddressUsecase {}
class FakeAddAddressParams extends Fake implements AddAddressParams {}
class FakeRemoveAddressParams extends Fake implements RemoveAddressParams {}
class FakeAddress extends Fake implements Address {}

void main() {
  late NotebookBloc bloc;
  late MockAddAddressUsecase mockAddAddressUsecase;
  late MockGetAddressesUsecase mockGetAddressesUsecase;
  late MockRemoveAddressUsecase mockRemoveAddressUsecase;

  final tAddress = Address(
    cep: '01001-000',
    street: 'Bairro teste',
    number: 'lado ímpar',
    complement: '',
  );

  setUpAll(() {
    registerFallbackValue(FakeAddress());
    registerFallbackValue(FakeAddAddressParams());
    registerFallbackValue(FakeRemoveAddressParams());
  });

  setUp(() {
    mockAddAddressUsecase = MockAddAddressUsecase();
    mockGetAddressesUsecase = MockGetAddressesUsecase();
    mockRemoveAddressUsecase = MockRemoveAddressUsecase();

    when(() => mockGetAddressesUsecase.call())
        .thenAnswer((_) async => Right([tAddress]));

    bloc = NotebookBloc(
      mockAddAddressUsecase,
      mockGetAddressesUsecase,
      mockRemoveAddressUsecase,
    );
  });

  group('NotebookBloc', () {
    blocTest<NotebookBloc, NotebookState>(
      'emits [NotebookLoading, NotebookLoaded] when LoadAddresses is added',
      build: () {
        when(() => mockGetAddressesUsecase.call())
            .thenAnswer((_) async => Right([tAddress]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAddresses()),
      expect: () => [
        isA<NotebookLoading>(),
        isA<NotebookLoaded>().having((state) => state.addresses, 'addresses', [tAddress]),
      ],
    );

    blocTest<NotebookBloc, NotebookState>(
      'emits [NotebookLoading, NotebookLoaded] when AddAddress is added',
      build: () {
        when(() => mockAddAddressUsecase.call(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(AddAddress(tAddress)),
      expect: () => [
        isA<NotebookLoading>(),
        isA<NotebookLoaded>(),
      ],
    );

    blocTest<NotebookBloc, NotebookState>(
      'emits [NotebookLoading, NotebookLoaded] when RemoveAddress is added',
      build: () {
        when(() => mockRemoveAddressUsecase.call(any()))
            .thenAnswer((_) async => Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveAddress(tAddress)),
      expect: () => [
        isA<NotebookLoading>(),
        isA<NotebookLoaded>().having((state) => state.addresses, 'addresses', []),
      ],
    );

  });
}
