import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle/puzzle.dart';
import 'package:flutter_puzzle/puzzle/puzzle_board.dart';
import 'package:flutter_puzzle/puzzle/puzzle_creator.dart';

/// パズルゲームのページ
class PuzzlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const path = 'assets/puzzle_img.jpg';
    final settings = PuzzleSettings.defaultSettings;
    final puzzleFuture = PuzzleCreator().createPuzzle(path, settings).then(
          (result) => result.when(
            success: (puzzle) => puzzle,
            failure: (error) => null,
          ),
        );

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: FutureBuilder<Puzzle?>(
          future: puzzleFuture,
          builder: (context, snapshot) {
            final puzzle = snapshot.data;

            if (puzzle == null) return const CircularProgressIndicator();

            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: PuzzleBoard(
                puzzle: puzzle,
                onPieceSelected: (piece) {},
              ),
            );
          },
        ),
      ),
    );
  }
}
