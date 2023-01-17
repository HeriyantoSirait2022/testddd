import 'package:testddd/presentation/pages/detailpage.dart';
import 'package:testddd/presentation/pages/homepage.dart';
import 'package:testddd/presentation/splash/splashscreen.dart';
import 'package:auto_route/annotations.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: Splashpage, initial: true),
    AutoRoute(page: HomePage),
  ],
)
class $AppRouter {}
