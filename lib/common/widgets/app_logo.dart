import 'package:flutter/material.dart';
import 'package:river_pod_mvvm/core/theme/res/res.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(R.assets.png.appLogo, fit : BoxFit.cover,height: size, width: size);
  }
}
