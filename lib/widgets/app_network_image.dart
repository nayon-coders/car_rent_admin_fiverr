import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'app_shmmer.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.height = 100,
      this.width = 100,
      this.fit = BoxFit.contain})
      : super(key: key);
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          AppShimmer(height: height, width: width),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
