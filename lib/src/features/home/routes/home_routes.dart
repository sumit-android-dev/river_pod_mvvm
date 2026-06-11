import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/features/home/views/main_screen.dart';

class HomeRoutes {
  static String get home => '/home';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: home,
      builder: (context, state) {
        return const MainScreen();
      },
    ),
  ];
}
