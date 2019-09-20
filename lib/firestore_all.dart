import 'dart:async';

import 'package:flutter/services.dart';

class FirestoreAll {
  static const MethodChannel _channel =
      const MethodChannel('firestore_all');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
