import 'dart:typed_data';
import 'dart:ui';

/// Imageのモック
class MockImg implements Image {
  MockImg(this._width, this._height);

  final int _width;
  final int _height;

  @override
  int get width => _width;

  @override
  int get height => _height;

  @override
  Image clone() {
    throw UnimplementedError();
  }

  @override
  bool get debugDisposed => throw UnimplementedError();

  @override
  List<StackTrace>? debugGetOpenHandleStackTraces() {
    throw UnimplementedError();
  }

  @override
  void dispose() {}

  @override
  bool isCloneOf(Image other) {
    throw UnimplementedError();
  }

  @override
  Future<ByteData?> toByteData({
    ImageByteFormat format = ImageByteFormat.rawRgba,
  }) {
    throw UnimplementedError();
  }
}
