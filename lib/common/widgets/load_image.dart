import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const LoadImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => placeholder ?? const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => errorWidget ?? const Icon(Icons.broken_image),
      fit: fit,
      width: width,
      height: height,
    );

    return image;
  }
}
