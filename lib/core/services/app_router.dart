import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsi_test/core/services/injection_container.dart';
import 'package:konsi_test/core/utils/typdefs.dart';

import '../../src/home/presentation/views/home_page.dart';
import '../../src/notebook/presentation/bloc/notebook_bloc.dart';
import '../../src/review/presentation/views/review_screen.dart';
import '../../src/splash_screen/presentation/views/splash_screen.dart';

class AppRouter {
  static const _home = '/home';
  static const _review = '/review';

  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: _home,
        name: _home,
        builder: (context, state) {
          final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
          return HomePage(initialTab: tab);
        },
      ),
      GoRoute(
        path: _review,
        name: _review,
        builder: (context, state) {
          final args = state.extra as DataMap;
          final cep = args['cep'];
          final formattedAddress = args['formattedAddress']!;
          return BlocProvider.value(
            value: sl<NotebookBloc>(),
            child: ReviewScreen(
              cep: cep,
              formattedAddress: formattedAddress,
            ),
          );
        },
      ),
    ],
  );
}

class RouterHelper {
  RouterHelper._();

  static const _home = '/home';
  static const _review = '/review';

  static void goHome(BuildContext context, {int tab = 0}) {
    context.goNamed(_home, queryParameters: {'tab': '$tab'});
  }

  static void goReview(BuildContext context, {required String cep, required String formattedAddress}) {
    context.goNamed(_review, extra: {'cep': cep, 'formattedAddress': formattedAddress});
  }
}