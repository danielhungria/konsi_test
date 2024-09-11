import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:konsi_test/src/map/domain/entities/cep.dart';
import 'package:konsi_test/src/map/domain/usecases/fetch_cep.dart';
import 'package:konsi_test/src/map/domain/usecases/add_history.dart';
import 'package:konsi_test/src/map/domain/usecases/get_history.dart';
import 'package:konsi_test/src/map/presentation/bloc/map_bloc.dart';
import 'package:konsi_test/core/services/geocoding_service.dart';
import 'package:konsi_test/core/errors/failures.dart';

class MockFetchCepUsecase extends Mock implements FetchCepUsecase {}

class MockGetHistoryUsecase extends Mock implements GetHistoryUsecase {}

class MockAddHistoryUsecase extends Mock implements AddHistoryUsecase {}

class MockGeocodingService extends Mock implements GeocodingService {}

class FakeFetchCepParams extends Fake implements FetchCepParams {}

class FakeCep extends Fake implements Cep {}

void main() {
  late MapBloc bloc;
  late MockFetchCepUsecase mockFetchCepUsecase;
  late MockGetHistoryUsecase mockGetHistoryUsecase;
  late MockAddHistoryUsecase mockAddHistoryUsecase;
  late MockGeocodingService mockGeocodingService;

  final tCep = Cep(
    cep: '01001-000',
    bairro: 'Bairro teste',
    logradouro: 'lado ímpar',
    localidade: 'Teste',
    estado: 'BA',
    ddd: '71',
    uf: 'BA',
  );

  setUpAll(() {
    registerFallbackValue(FakeFetchCepParams());
    registerFallbackValue(FakeCep());
  });

  setUp(() {
    mockFetchCepUsecase = MockFetchCepUsecase();
    mockGetHistoryUsecase = MockGetHistoryUsecase();
    mockAddHistoryUsecase = MockAddHistoryUsecase();
    mockGeocodingService = MockGeocodingService();

    when(() => mockGetHistoryUsecase.call()).thenAnswer((_) async => Right([tCep]));

    bloc = MapBloc(
      mockFetchCepUsecase,
      mockGeocodingService,
      mockGetHistoryUsecase,
      mockAddHistoryUsecase,
    );
  });

  group('MapBloc', () {
    blocTest<MapBloc, MapState>(
      'emits [SearchResults] when SearchChanged is added',
      build: () {
        when(() => mockGetHistoryUsecase.call()).thenAnswer((_) async => Right([tCep]));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchChanged('01001-000')),
      expect: () => [isA<SearchResults>()],
    );

    blocTest<MapBloc, MapState>(
      'emits [SearchResultError] when ClickSearch is added and fetchCepUsecase fails',
      build: () {
        when(() => mockFetchCepUsecase.call(any()))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server Error', statusCode: 500)));
        return bloc;
      },
      act: (bloc) => bloc.add(const ClickSearch('01001-000')),
      expect: () => [isA<SearchResultError>()],
    );

    blocTest<MapBloc, MapState>(
      'emits [SearchResults, ShowBottomSheetState, MapWithMarkers] when ResultSelected is added and geocodingService succeeds',
      build: () {
        when(() => mockGeocodingService.getLatLngFromCep(any())).thenAnswer((_) async => const LatLng(0, 0));
        return bloc;
      },
      act: (bloc) => bloc.add(ResultSelected(tCep)),
      expect: () => [isA<ShowBottomSheetState>(), isA<MapWithMarkers>()],
    );

    blocTest<MapBloc, MapState>(
      'emits [MapError] when ResultSelected is added and geocodingService fails',
      build: () {
        when(() => mockGeocodingService.getLatLngFromCep(any())).thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(ResultSelected(tCep)),
      expect: () => [isA<MapError>()],
    );
  });
}
