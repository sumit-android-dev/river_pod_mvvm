import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod_mvvm/common/widgets/app_bar.dart';
import 'package:river_pod_mvvm/core/theme/color/colors.dart';
import 'package:river_pod_mvvm/core/theme/style/text_style.dart';
import 'package:river_pod_mvvm/di/providers/dependency_injector.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _UserViewState();
}

class _UserViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authViewModelProvider).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarView(title: "Home"),
      body: SafeArea(child: Container()),
    );
  }
}
