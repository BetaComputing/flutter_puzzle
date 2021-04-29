import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:flutter_puzzle/puzzle/puzzle_board.dart';
import 'package:flutter_puzzle/puzzle/puzzle_creator.dart';
import 'package:flutter_puzzle/puzzle/puzzle_page_bloc.dart';
import 'package:flutter_puzzle/puzzle/puzzle_shuffler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// パズルゲームのページ
class PuzzlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const path = 'assets/puzzle_img.jpg';

    return Provider<PuzzlePageBloc>(
      create: (context) => PuzzlePageBloc(
        path,
        PuzzleCreator(),
        PuzzleShuffler(),
      ),
      dispose: (context, bloc) => bloc.dispose(),
      child: _PuzzlePage(),
    );
  }
}

class _PuzzlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<_PuzzlePage> {
  static const MaxWidth = 500.0;

  final _compositeSubscription = CompositeSubscription();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<PuzzlePageBloc>(context);
    bloc.puzzleCompletedEvent
        .listen((_) => _showCompletedDialog(bloc))
        .addTo(_compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PuzzlePageBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(child: _buildBody(bloc)),
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  //  ボディ部を生成する。
  Widget _buildBody(PuzzlePageBloc bloc) {
    return StreamBuilder<PuzzleLoadingState>(
      stream: bloc.loadingState,
      initialData: const PuzzleLoadingState.loading(),
      builder: (context, snapshot) {
        final state = snapshot.requireData;

        return state.when(
          loading: () => const CircularProgressIndicator(),
          success: (puzzle) => _buildPuzzle(bloc, puzzle),
          failed: () => _buildErrorMessage(bloc),
        );
      },
    );
  }

  //  パズルのUIを生成する。
  Widget _buildPuzzle(PuzzlePageBloc bloc, Puzzle puzzle) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: MaxWidth),
        child: PuzzleBoard(
          puzzle: puzzle,
          onPieceSelected: bloc.onPieceSelected,
        ),
      ),
    );
  }

  //  エラーメッセージを生成する。
  Widget _buildErrorMessage(PuzzlePageBloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'パズルの読み込みに失敗しました。',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => bloc.onReloadRequested(),
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          child: const Text('再読み込み'),
        ),
      ],
    );
  }

  //  完成ダイアログを表示する。
  void _showCompletedDialog(PuzzlePageBloc bloc) {
    final dialog = AlertDialog(
      title: const Text('パズル完成!'),
      content: const Text('おめでとうございます。もう一度遊びましょう!'),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: () {
            bloc.onReloadRequested();
            Navigator.of(context).pop();
          },
          child: const Text('もう一度'),
        ),
      ],
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog,
    );
  }
}
