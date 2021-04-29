import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:test/test.dart';

import 'mock_img.dart';

void main() {
  group('パズルのテスト', () {
    test('3x3のパズルのテスト', () {
      final img = MockImg(256, 256);
      final settings = PuzzleSettings(hDiv: 3, vDiv: 3, blankIndex: 8);
      final puzzle = Puzzle(img, settings);

      //  初期配置:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] [7] ( )

      //  ピースの数が3x3で9ピースであるはず。
      expect(puzzle.pieces.length, equals(3 * 3));

      //  指定した設定通り、index=8のみが空白ピースであり、
      //  index=5, index=7のみが移動可能ピースであるはず。
      for (var i = 0; i < 9; i++) {
        final expectedToBeBlank = i == 8;
        final expectedToBeMovable = i == 5 || i == 7;

        expect(puzzle.pieces[i].isBlankPiece, equals(expectedToBeBlank));
        expect(puzzle.pieces[i].isMovable, equals(expectedToBeMovable));
      }

      //  初期状態では完成状態であるはず。
      expect(puzzle.isCompleted, equals(true));

      //  index=7のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] [7] ( )
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] ( ) [7]
      //  パズルは未完成で、index=4, 6, 7のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 7,
        expectedToBeCompleted: false,
        movableIndices: [4, 6, 7],
      );

      //  index=4のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] ( ) [7]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] ( ) [5]
      //  [6] [4] [7]
      //  パズルは未完成で、index=1, 3, 5, 4のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 4,
        expectedToBeCompleted: false,
        movableIndices: [1, 3, 5, 4],
      );

      //  index=5のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] ( ) [5]
      //  [6] [4] [7]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [5] ( )
      //  [6] [4] [7]
      //  パズルは未完成で、index=2, 5, 7のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 5,
        expectedToBeCompleted: false,
        movableIndices: [2, 5, 7],
      );

      //  index=7のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [5] ( )
      //  [6] [4] [7]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [5] [7]
      //  [6] [4] ( )
      //  パズルは未完成で、index=7, 4のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 7,
        expectedToBeCompleted: false,
        movableIndices: [7, 4],
      );

      //  index=4のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [5] [7]
      //  [6] [4] ( )
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [5] [7]
      //  [6] ( ) [4]
      //  パズルは未完成で、index=5, 6, 4のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 4,
        expectedToBeCompleted: false,
        movableIndices: [5, 6, 4],
      );

      //  index=5のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [5] [7]
      //  [6] ( ) [4]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] ( ) [7]
      //  [6] [5] [4]
      //  パズルは未完成で、index=1, 3, 7, 5のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 5,
        expectedToBeCompleted: false,
        movableIndices: [1, 3, 7, 5],
      );

      //  index=7のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] ( ) [7]
      //  [6] [5] [4]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [7] ( )
      //  [6] [5] [4]
      //  パズルは未完成で、index=2, 7, 4のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 7,
        expectedToBeCompleted: false,
        movableIndices: [2, 7, 4],
      );

      //  index=4のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [7] ( )
      //  [6] [5] [4]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [7] [4]
      //  [6] [5] ( )
      //  パズルは未完成で、index=4, 5のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 4,
        expectedToBeCompleted: false,
        movableIndices: [4, 5],
      );

      //  index=5のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [7] [4]
      //  [6] [5] ( )
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [7] [4]
      //  [6] ( ) [5]
      //  パズルは未完成で、index=7, 6, 5のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 5,
        expectedToBeCompleted: false,
        movableIndices: [7, 6, 5],
      );

      //  index=7のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [7] [4]
      //  [6] ( ) [5]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] ( ) [4]
      //  [6] [7] [5]
      //  パズルは未完成で、index=1, 3, 4, 7のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 7,
        expectedToBeCompleted: false,
        movableIndices: [1, 3, 4, 7],
      );

      //  index=4のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] ( ) [4]
      //  [6] [7] [5]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [4] ( )
      //  [6] [7] [5]
      //  パズルは未完成で、index=2, 4, 5のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 4,
        expectedToBeCompleted: false,
        movableIndices: [2, 4, 5],
      );

      //  index=5のピースを移動させる。
      //  移動前の配置:
      //  [0] [1] [2]
      //  [3] [4] ( )
      //  [6] [7] [5]
      //  移動後の配置:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] [7] ( )
      //  パズルは完成し、index=5, 7のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 5,
        expectedToBeCompleted: true,
        movableIndices: [5, 7],
      );
    });

    test('4x5のパズルのテスト', () {
      final img = MockImg(512, 640);
      final settings = PuzzleSettings(hDiv: 5, vDiv: 4, blankIndex: 11);
      final puzzle = Puzzle(img, settings);

      //  初期配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] (  ) [12] [13] [14]
      //  [15] [16] [17] [18] [19]

      //  ピースの数が4x5で20ピースであるはず。
      expect(puzzle.pieces.length, equals(4 * 5));

      //  指定した設定通り、index=11のみが空白ピースであり、
      //  index=6, 10, 12, 16のみが移動可能ピースであるはず。
      for (var i = 0; i < 20; i++) {
        final expectedToBeBlank = i == 11;
        final expectedToBeMovable = i == 6 || i == 10 || i == 12 || i == 16;

        expect(puzzle.pieces[i].isBlankPiece, equals(expectedToBeBlank));
        expect(puzzle.pieces[i].isMovable, equals(expectedToBeMovable));
      }

      //  初期状態では完成状態であるはず。
      expect(puzzle.isCompleted, equals(true));

      //  index=10のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] (  ) [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  (  ) [10] [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=5, 10, 15のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 10,
        expectedToBeCompleted: false,
        movableIndices: [5, 10, 15],
      );

      //  index=15のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  (  ) [10] [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [15] [10] [12] [13] [14]
      //  (  ) [16] [17] [18] [19]
      //  パズルは未完成で、index=15, 16のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 15,
        expectedToBeCompleted: false,
        movableIndices: [15, 16],
      );

      //  index=15のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [15] [10] [12] [13] [14]
      //  (  ) [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  (  ) [10] [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=5, 10, 15のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 15,
        expectedToBeCompleted: false,
        movableIndices: [5, 10, 15],
      );

      //  index=10のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  (  ) [10] [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] (  ) [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  パズルは完成し、index=6, 10, 12, 16のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 10,
        expectedToBeCompleted: true,
        movableIndices: [6, 10, 12, 16],
      );

      //  index=12のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] (  ) [12] [13] [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] (  ) [13] [14]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=7, 12, 13, 17のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 12,
        expectedToBeCompleted: false,
        movableIndices: [7, 12, 13, 17],
      );

      //  index=13のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] (  ) [13] [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] [13] (  ) [14]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=8, 13, 14, 18のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 13,
        expectedToBeCompleted: false,
        movableIndices: [8, 13, 14, 18],
      );

      //  index=14のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] [13] (  ) [14]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] [13] [14] (  )
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=9, 14, 19のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 14,
        expectedToBeCompleted: false,
        movableIndices: [9, 14, 19],
      );

      //  index=9のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] [ 9]
      //  [10] [12] [13] [14] (  )
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] (  )
      //  [10] [12] [13] [14] [ 9]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=4, 8, 9のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 9,
        expectedToBeCompleted: false,
        movableIndices: [4, 8, 9],
      );

      //  index=4のピースを移動させる。
      //  移動前の配置:
      //  [ 0] [ 1] [ 2] [ 3] [ 4]
      //  [ 5] [ 6] [ 7] [ 8] (  )
      //  [10] [12] [13] [14] [ 9]
      //  [15] [16] [17] [18] [19]
      //  移動後の配置:
      //  [ 0] [ 1] [ 2] [ 3] (  )
      //  [ 5] [ 6] [ 7] [ 8] [ 4]
      //  [10] [12] [13] [14] [ 9]
      //  [15] [16] [17] [18] [19]
      //  パズルは未完成で、index=3, 4のみが移動可能であるはず。
      movePieces(
        puzzle,
        indexToMove: 4,
        expectedToBeCompleted: false,
        movableIndices: [3, 4],
      );
    });
  });
}

void movePieces(
  Puzzle puzzle, {
  required int indexToMove,
  required bool expectedToBeCompleted,
  required List<int> movableIndices,
}) {
  //  指定されたインデックスのピースを移動対象とし、移動させる。
  final pieceToMove = puzzle.pieces[indexToMove];
  puzzle.move(pieceToMove);

  //  完成状態を検証する。
  expect(puzzle.isCompleted, equals(expectedToBeCompleted));

  //  各ピースに対して、移動可能かどうかの検証を行う。
  for (var i = 0; i < puzzle.pieces.length; i++) {
    final expectedToBeMovable = movableIndices.contains(i);
    expect(puzzle.pieces[i].isMovable, equals(expectedToBeMovable));
  }
}
