import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_favor_method_channel.dart';

abstract class FlutterFavorPlatform extends PlatformInterface {
  /// Constructs a FlutterFavorPlatform.
  FlutterFavorPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFavorPlatform _instance = MethodChannelFlutterFavor();

  /// The default instance of [FlutterFavorPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFavor].
  static FlutterFavorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFavorPlatform] when
  /// they register themselves.
  static set instance(FlutterFavorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> version() {
    throw UnimplementedError('version() has not been implemented.');
  }

  Future start(String jsonConfig) {
    throw UnimplementedError('start(String jsonConfig) has not been implemented.');
  }

  Future stop() {
    throw UnimplementedError('start() has not been implemented.');
  }

}
