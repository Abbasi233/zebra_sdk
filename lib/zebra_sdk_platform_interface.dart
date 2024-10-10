import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zebra_sdk_method_channel.dart';

abstract class ZebraSdkPlatform extends PlatformInterface {
  /// Constructs a ZebraSdkPlatform.
  ZebraSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraSdkPlatform _instance = MethodChannelZebraSdk();

  /// The default instance of [ZebraSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZebraSdk].
  static ZebraSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZebraSdkPlatform] when
  /// they register themselves.
  static set instance(ZebraSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map<String, dynamic>> print(String btAddr, String content, String labelLength) {
    throw UnimplementedError('print() has not been implemented.');
  }
}
