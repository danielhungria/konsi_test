part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
}

Future<void> _initOnBoarding() async {
  sl
    ..registerFactory(
      () => NotebookBloc(),
    )
    ..registerFactory(
      () => MapBloc(),
    )
      ..registerFactory(
      () => NavigationBloc(),
    );
}
