import 'package:async/async.dart';
import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:flutter_puzzle/puzzle/puzzle_creator.dart';
import 'package:flutter_puzzle/puzzle/puzzle_page_bloc.dart';
import 'package:flutter_puzzle/puzzle/puzzle_shuffler.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'mock_img.dart';
import 'puzzle_page_bloc_test.mocks.dart';

@GenerateMocks([PuzzleCreator, PuzzleShuffler])
void main() {
  //  3x3パズル・空白ピース右下・初期シャッフル[7]のみ移動
  //  [0] [1] [2]
  //  [3] [4] [5]
  //  [6] [7] ( )
  //  初期シャッフル適用後:
  //  [0] [1] [2]
  //  [3] [4] [5]
  //  [6] ( ) [7]

  const assetPath = 'PATH';
  final settings = PuzzleSettings(hDiv: 3, vDiv: 3, blankIndex: 8);
  final img = MockImg(512, 512);
  final creator = MockPuzzleCreator();
  final shuffler = MockPuzzleShuffler();

  //  初期配置のシャッフル操作において、
  //  簡易的に[7]のピースの1箇所のみを空白ピースと入れ替えるようにする。
  when(shuffler.shuffle(any)).thenAnswer((i) {
    final puzzle = i.positionalArguments.first as Puzzle;
    puzzle.move(puzzle.pieces[7]);
  });

  group('パズルゲームのページのBLoCのテスト', () {
    test('パズルの読み込みに成功するとパズルデータが通知される', () async {
      //  パズルの読み込みに成功するように設定する。
      final result = PuzzleCreatorResult.success(Puzzle(img, settings));
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => result);

      //  BLoCを生成する。
      //  (同時にパズルの読み込み処理が走る。)
      final bloc = PuzzlePageBloc(assetPath, creator, shuffler);

      //  パズルデータの読み込みに成功し、パズルデータ (非null) が通知されるはず。
      await expectLater(bloc.puzzle, emitsThrough(isNotNull));
    });

    test('パズルを移動させるとパズルデータが更新される', () async {
      //  パズルの読み込みに成功するように設定する。
      final result = PuzzleCreatorResult.success(Puzzle(img, settings));
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => result);

      final bloc = PuzzlePageBloc(assetPath, creator, shuffler);

      //  パズルデータを監視する。
      final puzzleQueue = StreamQueue(bloc.puzzle);

      //  パズルデータが読み込まれるまで (非nullなパズルデータが通知されるまで) 待機する。
      Puzzle? puzzle;
      do {
        puzzle = await puzzleQueue.next;
      } while (puzzle == null);

      //  [4]のピースを移動させ、この操作以降、新たにパズルデータの通知が来ることを確認する。
      //  移動前:
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] ( ) [7]
      //  移動後:
      //  [0] [1] [2]
      //  [3] ( ) [5]
      //  [6] [4] [7]
      bloc.onPieceSelected(puzzle.pieces[4]);
      await expectLater(puzzleQueue.next, completes);
    });

    test('パズルを完成させると完成イベントが通知される', () async {
      //  パズルの読み込みに成功するように設定する。
      final result = PuzzleCreatorResult.success(Puzzle(img, settings));
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => result);

      final bloc = PuzzlePageBloc(assetPath, creator, shuffler);

      //  完成イベントを監視する。
      final completedEventQueue = StreamQueue(bloc.puzzleCompletedEvent);

      //  [7]のピースを移動させることでパズルを完成させる。
      //  [0] [1] [2]
      //  [3] [4] [5]
      //  [6] ( ) [7]
      final puzzle = await bloc.puzzle.whereType<Puzzle>().first;
      bloc.onPieceSelected(puzzle.pieces[7]);

      //  完成イベントが通知されるはず。
      await expectLater(completedEventQueue.next, completes);
    });

    test('パズルの読み込みに失敗するとパズルが表示されない', () async {
      //  パズルの読み込みに失敗するように設定する。
      const result = PuzzleCreatorResult.failure('ERROR');
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => result);

      //  BLoCを生成する。
      //  (同時にパズルの読み込み処理が走る。)
      final bloc = PuzzlePageBloc(assetPath, creator, shuffler);

      //  読み込み処理が終わるまで待機する。
      await expectLater(
        bloc.isProgressIndicatorVisible,
        emitsThrough(equals(false)),
      );

      //  パズルデータの読み込みに失敗し、nullが通知されるはず。
      await expectLater(bloc.puzzle, emits(isNull));
    });

    test('再読み込みを要求するとパズルの読み込み処理が再び実行される', () async {
      //  はじめはパズルの読み込みに失敗するように設定する。
      const failure = PuzzleCreatorResult.failure('ERROR');
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => failure);

      //  BLoCを生成する。
      //  (同時にパズルの読み込み処理が走る。)
      final bloc = PuzzlePageBloc(assetPath, creator, shuffler);

      //  読み込み処理が終わるまで待機する。
      await expectLater(
        bloc.isProgressIndicatorVisible,
        emitsThrough(equals(false)),
      );

      //  次はパズルの読み込みに成功するように設定する。
      final success = PuzzleCreatorResult.success(Puzzle(img, settings));
      when(creator.createPuzzle(any, any)).thenAnswer((_) async => success);

      //  再読み込みの要求を掛ける。
      bloc.onReloadRequested();

      //  パズルデータの読み込みに成功し、パズルデータ (非null) が通知されるはず。
      await expectLater(bloc.puzzle, emitsThrough(isNotNull));
    });
  });
}
