import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_favor_platform_interface.dart';

/// An implementation of [FlutterFavorPlatform] that uses method channels.
class MethodChannelFlutterFavor extends FlutterFavorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_favor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
