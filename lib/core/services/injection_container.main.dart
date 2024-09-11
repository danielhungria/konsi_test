part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initHive();
}

Future<void> _initOnBoarding() async {
  // DataSources
  sl
    ..registerLazySingleton<CepRemoteDataSource>(
      () => CepRemoteDataSourceImpl(
        client: sl(),
      ),
    )
    ..registerLazySingleton<CepLocalDataSource>(
      () => CepLocalDataSourceImpl(),
    )
    ..registerLazySingleton<NotebookLocalDataSource>(
      () => NotebookLocalDataSourceImpl(),
    );

  // Repositories
  sl
    ..registerLazySingleton<CepRepository>(
      () => CepRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<NotebookRepository>(
      () => NotebookRepositoryImpl(
        localDataSource: sl(),
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
      () => AddHistoryUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => GetHistoryUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => RemoveAddressUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => AddAddressUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => GetAddressesUsecase(
        sl(),
      ),
    );


  // Bloc
  sl
    ..registerLazySingleton(
      () => NotebookBloc(
        sl(),
        sl(),
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => MapBloc(
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    )
    ..registerFactory(
      () => NavigationBloc(),
    );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GeocodingService(client: sl()));
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CepAdapter());
  Hive.registerAdapter(AddressAdapter());

  await CepLocalDataSourceImpl.init();
  await NotebookLocalDataSourceImpl.init();
}
