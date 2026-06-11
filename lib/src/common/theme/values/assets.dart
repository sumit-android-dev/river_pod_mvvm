part of '../res/res.dart';

// SVG & PNG asset path helper.
String png(String fileName) => 'assets/images/$fileName.png';

String svg(String fileName) => 'assets/svg/$fileName.svg';

class ResAssets {
  final PngAssets png = PngAssets();
  final SvgAssets svg = SvgAssets();
}


