import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:flutter_puzzle/puzzle/puzzle_creator.dart';
import 'package:flutter_puzzle/puzzle/puzzle_shuffler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'puzzle_page_bloc.freezed.dart';

/// パズルゲームのページのBLoC
class PuzzlePageBloc {
  PuzzlePageBloc(this._assetPath, this._creator, this._shuffler) {
    _initPuzzle();
  }

  final String _assetPath;
  final PuzzleCreator _creator;
  final PuzzleShuffler _shuffler;

  final _loadingState = BehaviorSubject.seeded(
    const PuzzleLoadingState.loading(),
  );

  final _puzzleCompletedEvent = PublishSubject<void>();

  //  現在のPuzzle
  Puzzle? get _puzzle => _loadingState.requireValue
      .maybeWhen(success: (puzzle) => puzzle, orElse: () => null);

  /// パズルの読み込み状態
  Stream<PuzzleLoadingState> get loadingState => _loadingState.stream;

  /// パズルの完成を通知するイベント
  Stream<void> get puzzleCompletedEvent => _puzzleCompletedEvent.stream;

  /// ピースが選択されたとき。
  void onPieceSelected(Piece piece) {
    if (piece.isMovable) {
      final puzzle = _puzzle!;

      puzzle.move(piece);
      _updatePuzzle(puzzle);

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
    _loadingState.close();
  }

  //  パズルを初期化する。
  Future<void> _initPuzzle() async {
    _loadingState.add(const PuzzleLoadingState.loading());

    final settings = PuzzleSettings.defaultSettings;
    final result = await _creator.createPuzzle(_assetPath, settings);
    await Future<void>.delayed(const Duration(seconds: 1));

    result.when(
      success: (puzzle) {
        _shuffler.shuffle(puzzle);
        _updatePuzzle(puzzle);
      },
      failure: (error) {
        _loadingState.add(const PuzzleLoadingState.failed());
      },
    );
  }

  //  Puzzleを更新する。
  void _updatePuzzle(Puzzle puzzle) {
    _loadingState.add(PuzzleLoadingState.success(puzzle));
  }
}

/// パズルの読み込み状態
@freezed
class PuzzleLoadingState with _$PuzzleLoadingState {
  /// 読み込み中
  const factory PuzzleLoadingState.loading() = _Loading;

  /// 読み込み成功
  const factory PuzzleLoadingState.success(Puzzle puzzle) = _Success;

  /// 読み込み失敗
  const factory PuzzleLoadingState.failed() = _Failed;
}
