import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/di/dependency_injector.dart';
import 'package:river_pod_mvvm/src/features/settings/views/setting_view.dart';

class SettingRoutes {
  static String get setting => '/setting';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: setting,
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            return SettingView(
              settingViewModel: ref.read(settingViewModelProvider),
            );
          },
        );
      },
    ),
  ];
}
