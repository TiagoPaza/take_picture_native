
import 'dart:async';

import 'package:flutter/services.dart';

class TakePictureNative {
  static const MethodChannel _channel = MethodChannel("take_picture_native");

  static Future<List<String>> get openCamera async {
    return await _channel.invokeMethod("open_camera").then((data) =>  List<String>.from(data));
  }
}
