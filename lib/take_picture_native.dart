
import 'dart:async';

import 'package:flutter/services.dart';

class TakePictureNative {
  static const MethodChannel _channel = MethodChannel('take_picture_native');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
