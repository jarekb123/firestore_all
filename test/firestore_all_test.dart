import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firestore_all/firestore_all.dart';

void main() {
  const MethodChannel channel = MethodChannel('firestore_all');

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
    expect(await FirestoreAll.platformVersion, '42');
  });
}
