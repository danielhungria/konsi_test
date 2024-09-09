part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
}

Future<void> _initOnBoarding() async {
  // DataSources
  sl.registerLazySingleton<CepRemoteDataSource>(
    () => CepRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<CepRepository>(
    () => CepRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // UseCases
  sl
    ..registerLazySingleton(
      () => FetchCepUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => FetchCepParams(
        cep: '',
      ),
    );

  // Bloc
  sl
    ..registerFactory(
      () => NotebookBloc(),
    )
    ..registerFactory(
      () => MapBloc(
        sl(),
        sl(),
      ),
    )
    ..registerFactory(
      () => NavigationBloc(),
    );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GeocodingService());
}
