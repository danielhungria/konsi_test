import 'package:go_router/go_router.dart';
import 'package:konsi_test/src/home/presentation/views/home_page.dart';

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
        builder: (context, state) => const HomePage(),
      )
    ],
  );
}