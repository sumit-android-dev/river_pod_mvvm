import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/features/auth/routes/auth_routes.dart';
import 'package:river_pod_mvvm/features/settings/routes/setting_routes.dart';
import 'package:river_pod_mvvm/features/home/routes/home_routes.dart';

class Routes {
  static String get home => HomeRoutes.home;
  static String get login => AuthRoutes.login;
  static String get splash => AuthRoutes.splash;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: splash,
    routes: [
      ...AuthRoutes().routes,
      ...SettingRoutes().routes,
      ...HomeRoutes().routes,
    ],
  );
}
