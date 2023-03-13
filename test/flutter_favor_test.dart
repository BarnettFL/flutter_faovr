import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_favor/flutter_favor.dart';
import 'package:flutter_favor/flutter_favor_platform_interface.dart';
import 'package:flutter_favor/flutter_favor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFavorPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFavorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFavorPlatform initialPlatform = FlutterFavorPlatform.instance;

  test('$MethodChannelFlutterFavor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFavor>());
  });

  test('getPlatformVersion', () async {
    FlutterFavor flutterFavorPlugin = FlutterFavor();
    MockFlutterFavorPlatform fakePlatform = MockFlutterFavorPlatform();
    FlutterFavorPlatform.instance = fakePlatform;

    expect(await flutterFavorPlugin.getPlatformVersion(), '42');
  });
}
