import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsi_test/core/services/injection_container.dart';

import '../../src/home/presentation/views/home_page.dart';
import '../../src/notebook/presentation/bloc/notebook_bloc.dart';
import '../../src/review/presentation/views/review_screen.dart';
import '../../src/splash_screen/presentation/views/splash_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
          return HomePage(initialTab: tab);
        },
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final cep = args['cep']!;
          final address = args['address']!;
          return BlocProvider.value(
            value: sl<NotebookBloc>(),
            child: ReviewScreen(cep: cep, address: address),
          );
        },
      ),
    ],
  );
}