import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/di/dependency_injector.dart';
import 'package:river_pod_mvvm/src/features/auth/views/login_screen.dart';
import 'package:river_pod_mvvm/src/features/auth/views/splash_screen.dart';

class AuthRoutes {
  static String get login => '/login';
  static String get splash => '/splash';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: splash,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
  ];
}
