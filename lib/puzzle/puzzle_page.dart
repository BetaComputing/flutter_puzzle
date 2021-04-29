import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle/puzzle.dart';
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
      body: Center(
        child: FutureBuilder<Puzzle?>(
          future: puzzleFuture,
          builder: (context, snapshot) {
            final puzzleImg = snapshot.data?.img;

            if (puzzleImg == null) return const CircularProgressIndicator();

            return SizedBox(
              width: puzzleImg.width.toDouble(),
              height: puzzleImg.height.toDouble(),
              child: CustomPaint(painter: _PuzzlePainter(puzzleImg)),
            );
          },
        ),
      ),
    );
  }
}

class _PuzzlePainter extends CustomPainter {
  _PuzzlePainter(this.img);

  static final _paint = Paint();
  final ui.Image img;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(img, Offset.zero, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
