import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/common/dependency_injectors/dependency_injector.dart';
import 'package:river_pod_mvvm/src/features/auth/views/login_screen.dart';

class AuthRoutes {
  static String get login => '/login';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
  ];
}
