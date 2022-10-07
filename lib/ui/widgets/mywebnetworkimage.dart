import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyWebImage extends StatelessWidget {
  final String url;
  MyWebImage(this.url);

  @override
  Widget build(BuildContext context) {
    String imageUrl = "image_url";
    // https://github.com/flutter/flutter/issues/41563
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int _) => ImageElement()..src = url,
    );
    return HtmlElementView(
      viewType: imageUrl,
    );
  }
}