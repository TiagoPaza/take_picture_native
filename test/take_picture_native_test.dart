import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_picture_native/take_picture_native.dart';

void main() {
  const MethodChannel channel = MethodChannel('take_picture_native');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TakePictureNative.platformVersion, '42');
  });
}
