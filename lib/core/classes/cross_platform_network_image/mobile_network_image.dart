import 'package:flutter/material.dart';
import 'cross_platform_network_image.dart';

class MobileNetworkImage implements CrossNetWorkImage{
  @override
  Widget getWidget(String url) {
    return Image.network("$url");
  }
}

CrossNetWorkImage getCrossNetWorkImage() => MobileNetworkImage();