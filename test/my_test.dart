import 'package:test/test.dart';

void main() {
  group('はじめてのテスト', () {
    test('1+2=3のテスト', () {
      expect(3, equals(1 + 2));
    });
    test('失敗するテスト', () {
      expect(9, equals(1 + 2));
    });
  });
}
