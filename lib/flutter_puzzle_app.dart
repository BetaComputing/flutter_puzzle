import 'package:flutter/material.dart';
import 'package:flutter_puzzle/puzzle/puzzle_page.dart';

/// Flutter製パズルアプリ
class FlutterPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_puzzle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PuzzlePage(),
    );
  }
}
