import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/common/widgets/app_logo.dart';
import 'package:river_pod_mvvm/core/theme/color/colors.dart';
import 'package:river_pod_mvvm/core/theme/res/res.dart';
import 'package:river_pod_mvvm/core/theme/style/text_style.dart';
import 'package:river_pod_mvvm/di/providers/dependency_injector.dart';
import 'package:river_pod_mvvm/routes/routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final viewModel = ref.read(authViewModelProvider);
    final isLogin = await viewModel.isLogin();

    if (isLogin) {
      context.go(Routes.home);
    } else {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(size: 160.0),
          ],
        ),
      ),
    );
  }
}
