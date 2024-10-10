import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zebra_sdk_platform_interface.dart';

/// An implementation of [ZebraSdkPlatform] that uses method channels.
class MethodChannelZebraSdk extends ZebraSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zebra_sdk');

  @override
  Future<Map<String, dynamic>> print(String btAddr, String content, String labelLength) async {
    Map<dynamic, dynamic>? returnValue = {};
    try {
      returnValue = await methodChannel.invokeMapMethod(
        'print',
        <String, dynamic>{
          'btAddr': btAddr,
          'content': content,
          'labelLength': labelLength,
        },
      );
    } catch (e) {
      log(e.toString());
    }

    return returnValue!.map<String, dynamic>((key, value) => MapEntry(key, value));
  }
}
