import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:flutter_puzzle/puzzle/puzzle_creator.dart';
import 'package:flutter_puzzle/puzzle/puzzle_shuffler.dart';
import 'package:rxdart/rxdart.dart';

/// パズルゲームのページのBLoC
class PuzzlePageBloc {
  PuzzlePageBloc(this._assetPath, this._creator, this._shuffler) {
    _initPuzzle();
  }

  final String _assetPath;
  final PuzzleCreator _creator;
  final PuzzleShuffler _shuffler;

  final _isLoading = BehaviorSubject.seeded(true);
  final _puzzle = BehaviorSubject<Puzzle?>.seeded(null);
  final _puzzleCompletedEvent = PublishSubject<void>();

  /// ProgressIndicatorの可視性
  Stream<bool> get isProgressIndicatorVisible => _isLoading.stream;

  /// パズル
  /// (ピースの更新ごとに値が通知される。エラー発生時はnullを通知する。)
  Stream<Puzzle?> get puzzle => _puzzle.stream;

  /// パズルの完成を通知するイベント
  Stream<void> get puzzleCompletedEvent => _puzzleCompletedEvent.stream;

  /// ピースが選択されたとき。
  void onPieceSelected(Piece piece) {
    if (piece.isMovable) {
      final puzzle = _puzzle.requireValue!;

      puzzle.move(piece);
      _puzzle.add(puzzle);

      if (puzzle.isCompleted) {
        _puzzleCompletedEvent.add(null);
      }
    }
  }

  /// 再読み込み処理が要求されたとき。
  void onReloadRequested() {
    _initPuzzle();
  }

  /// 終了処理を行う。
  void dispose() {
    _isLoading.close();
    _puzzle.close();
    _puzzleCompletedEvent.close();
  }

  //  パズルを初期化する。
  Future<void> _initPuzzle() async {
    _isLoading.add(true);

    final settings = PuzzleSettings.defaultSettings;
    final result = await _creator.createPuzzle(_assetPath, settings);

    result.when(
      success: (puzzle) {
        _shuffler.shuffle(puzzle);
        _puzzle.add(puzzle);
      },
      failure: (error) {
        _puzzle.add(null);
      },
    );

    _isLoading.add(false);
  }
}
