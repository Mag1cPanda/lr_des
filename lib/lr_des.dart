
import 'dart:async';

import 'package:flutter/services.dart';

class LrDes {
  static const MethodChannel _channel = MethodChannel('lr_des');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> encryptToBase64(String string, String key) async {
    if (string.isEmpty || key.isEmpty) {
      return '';
    }
    final String encryString = await _channel.invokeMethod('encryptToBase64', [string, key]);
    return encryString;
  }

  static Future<String> decryptFromBase64(String hex, String key) async {
    if (hex.isEmpty || key.isEmpty) {
      return '';
    }
    final String decryString = await _channel.invokeMethod('decryptFromBase64', [hex, key]);
    return decryString;
  }
}
