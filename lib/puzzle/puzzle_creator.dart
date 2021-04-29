import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'puzzle_creator.freezed.dart';

/// [Puzzle]の生成ロジック
class PuzzleCreator {
  /// [Puzzle]を生成する。
  Future<PuzzleCreatorResult> createPuzzle(
    String assetPath,
    PuzzleSettings settings,
  ) async {
    try {
      final stream = _createAssetImageStream(assetPath);
      final img = await _createImage(stream);
      final puzzle = Puzzle(img, settings);

      return PuzzleCreatorResult.success(puzzle);
    } catch (e) {
      return PuzzleCreatorResult.failure(e);
    }
  }

  //  アセット画像のImageStreamを生成する。
  ImageStream _createAssetImageStream(String assetPath) =>
      AssetImage(assetPath).resolve(ImageConfiguration.empty);

  //  ui.Imageを生成する。
  Future<ui.Image> _createImage(ImageStream stream) async {
    final completer = Completer<ImageInfo>();
    stream.addListener(
      ImageStreamListener(
        (info, _) => completer.complete(info),
        onError: (error, stack) => completer.completeError(error, stack),
      ),
    );

    return (await completer.future).image;
  }
}

/// [PuzzleCreator]の結果
@freezed
class PuzzleCreatorResult with _$PuzzleCreatorResult {
  /// 成功
  const factory PuzzleCreatorResult.success(Puzzle puzzle) = _Success;

  /// 失敗
  const factory PuzzleCreatorResult.failure(Object error) = _Failure;
}
