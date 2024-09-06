import 'package:go_router/go_router.dart';
import '../../src/home/presentation/views/home_page.dart';
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
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/review',
        builder: (context, state) {
          final args = state.extra as Map<String, String>;
          final cep = args['cep']!;
          final address = args['address']!;
          return ReviewScreen(cep: cep, address: address);
        },
      ),
    ],
  );
}