
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_network_image/cross_platform_network_image_stub.dart'

if (dart.library.io) 'mobile_network_image.dart' if (dart.library.js) 'web_network_image.dart';

abstract class CrossNetWorkImage {
  Widget getWidget(String url);
  factory CrossNetWorkImage() => getCrossNetWorkImage();
}