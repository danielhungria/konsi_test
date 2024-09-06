import 'package:flutter/material.dart';
import 'package:konsi_test/core/res/app_theme.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Konsi App',
      theme: AppTheme.theme,
      routerConfig: _appRouter.router,
    );
  }
}
