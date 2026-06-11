import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod_mvvm/src/common/dependency_injectors/dependency_injector.dart';
import 'package:river_pod_mvvm/src/common/routes/routes.dart';
import 'package:river_pod_mvvm/src/common/state_management/state_management.dart';
import 'package:river_pod_mvvm/src/features/settings/models/setting_model.dart';
import 'package:river_pod_mvvm/src/features/settings/view_models/setting_view_model.dart';

void main() {
  final Routes appRoutes = Routes();
  runApp(ProviderScope(child: MyApp(appRoutes: appRoutes)));
}

class MyApp extends ConsumerWidget {
  final Routes appRoutes;

  const MyApp({super.key, required this.appRoutes});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appFutureProvider);
    final settingViewModel = ref.watch(settingViewModelProvider);
    return StateBuilderWidget<SettingViewModel, SettingModel>(
      viewModel: settingViewModel,
      builder: (context, settingModel) {
        return MaterialApp.router(
          title: 'Riverpod MVVM',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: settingModel.isDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: appRoutes.routes,
        );
      },
    );
  }
}
