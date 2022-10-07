import 'cross_platform_network_image.dart';
import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyWebImage extends StatelessWidget {
  final String url;
  MyWebImage(this.url);

  @override
  Widget build(BuildContext context) {
    String imageUrl = "image_url_$url";
    // https://github.com/flutter/flutter/issues/41563
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()..src = url..style.width = "100%"..style.height = "100%"..style.borderRadius = "10px",
    );
    return HtmlElementView(
      viewType: imageUrl,
    );
  }
}

class WebNetworkImage implements CrossNetWorkImage{
  @override
  Widget getWidget(String url) {
    return MyWebImage(url);
  }
}

CrossNetWorkImage getCrossNetWorkImage() => WebNetworkImage();