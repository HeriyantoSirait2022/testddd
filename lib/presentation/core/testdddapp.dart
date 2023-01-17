import 'package:testddd/presentation/routes/router.gr.dart';
import 'package:testddd/presentation/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestdddApp extends StatelessWidget {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      title: 'Test DDD',
      debugShowCheckedModeBanner: false,
      theme: Apptheme.theme,
    );
  }
}
