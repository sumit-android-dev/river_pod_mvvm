import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/features/auth/routes/auth_routes.dart';
import 'package:river_pod_mvvm/src/features/settings/routes/setting_routes.dart';
import 'package:river_pod_mvvm/src/features/users/routes/user_routes.dart';

class Routes {
  static String get home => UserRoutes.users;
  static String get login => AuthRoutes.login;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: login,
    routes: [
      ...AuthRoutes().routes,
      ...UserRoutes().routes,
      ...SettingRoutes().routes,
    ],
  );
}
