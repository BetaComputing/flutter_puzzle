import 'dart:math';

import 'package:flutter_puzzle/puzzle/puzzle.dart';

/// パズルのシャッフルロジック
class PuzzleShuffler {
  /// シャッフルする。
  void shuffle(Puzzle puzzle, [int? seed = null]) {
    const minSteps = 100;
    const maxSteps = 300;

    final random = _createRandom(seed);
    final steps = minSteps + random.nextInt(maxSteps - minSteps);

    final blankPiece = puzzle.pieces.firstWhere((p) => p.isBlankPiece);
    var blankPos = blankPiece.currentPos;

    for (var i = 0; i < steps; i++) {
      blankPos = _movePieces(puzzle, random, blankPos);
    }
  }

  //  Randomを生成する。
  Random _createRandom(int? seed) =>
      Random(seed ?? DateTime.now().millisecondsSinceEpoch);

  //  ピースを移動させる。
  PiecePos _movePieces(Puzzle puzzle, Random random, PiecePos blankPos) {
    //  移動可能なピースの集団を洗い出し、さらにそこから、移動可能なピースのうち、
    //  移動後の位置がそのピースのオリジナルの位置とは異なるようなピースに対して、
    //  2倍の当選確率を設定した選択候補のピースの集団を求める。
    final movables = puzzle.pieces.where((p) => p.isMovable);
    final biasedCandidates = movables.expand(
      (p) => p.originalPos == blankPos ? [p] : [p, p],
    );

    final targetPiece = _chooseRandomly(biasedCandidates.toList(), random);
    final nextBlankPos = targetPiece.currentPos;
    puzzle.move(targetPiece);

    return nextBlankPos;
  }

  //  候補の中から中からランダムに1つのピースを選択する。
  Piece _chooseRandomly(List<Piece> candidates, Random random) {
    final lastIndex = candidates.length - 1;
    return candidates[random.nextInt(lastIndex)];
  }
}
