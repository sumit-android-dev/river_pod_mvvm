import 'package:flutter/material.dart';
import 'package:river_pod_mvvm/core/theme/color/colors.dart';
import 'package:river_pod_mvvm/core/theme/style/text_style.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: AppColors.blue35,
      title: Text(title, style: AppTextStyle.onestSemiBold(textColor: AppColors.white, textSize: 20.0)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
