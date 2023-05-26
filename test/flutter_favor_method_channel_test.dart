import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_favor/flutter_favor_method_channel.dart';

void main() {
  MethodChannelFlutterFavor platform = MethodChannelFlutterFavor();
  const MethodChannel channel = MethodChannel('flutter_favor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('version', () async {
    expect(await platform.version(), '42');
  });
}
