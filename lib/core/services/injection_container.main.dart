part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initHive();
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
    ..registerLazySingleton(
      () => NotebookBloc(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => MapBloc(
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

  var historyBox = await Hive.openBox<Cep>('historyBox');
  var addressBox = await Hive.openBox<Address>('addressBox');

  sl.registerLazySingleton<Box<Cep>>(() => historyBox);
  sl.registerLazySingleton<Box<Address>>(() => addressBox);
}
