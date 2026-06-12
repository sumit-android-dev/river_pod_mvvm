import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod_mvvm/src/di/dependency_injector.dart';
import 'package:river_pod_mvvm/src/routes/routes.dart';

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
    return MaterialApp.router(
      title: 'Riverpod MVVM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.light,
      routerConfig: appRoutes.routes,
    );
  }
}
