import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;

  CachedImage(this.image, {this.height, this.width, this.radius, this.fit});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 4),
      child: image != null
          ? CachedNetworkImage(
              imageUrl: image,
              height: height ?? 70,
              width: width ?? 70,
              fit: fit ?? BoxFit.fill,
              errorWidget: (context, img, d) {
                return Image.asset('images/download.png');
              },
              placeholder: (context, string) {
                return Image.asset('images/download.png');
              },
            )
          : Image.asset(
              'images/download.png',
              height: height ?? 70,
              width: width ?? 70,
            ),
    );
  }
}
