import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for LogicalKeyboardKey
import '../logic/game_logic.dart';
import '../models/direction.dart';
import '../widgets/snake_segment.dart';
import '../widgets/food.dart';
import '../widgets/grass.dart';
import '../services/sound_manager.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int rows = 20;
  static const int columns = 20;
  late double pixelSize;
  late GameLogic gameLogic;
  final SoundManager soundManager = SoundManager();
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startGame());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pixelSize = 40.0;
    gameLogic = GameLogic(rows: rows, columns: columns, soundManager: soundManager);
  }

  void _startGame() {
    setState(() {
      isGameStarted = true;
      gameLogic.start(_updateUI, _onGameOver);
    });
  }

  void _updateUI() {
    setState(() {});
  }

  void _onGameOver() {
    setState(() {
      isGameStarted = false;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Your score: ${gameLogic.score}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _restartGame() {
    setState(() {
      gameLogic.reset();
      _startGame();
    });
  }

  // Arrow keys for direction change
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          gameLogic.changeDirection(Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          gameLogic.changeDirection(Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          gameLogic.changeDirection(Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          gameLogic.changeDirection(Direction.right);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snake Game')),
      body: Focus(
        autofocus: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          _handleKeyEvent(event);  // Handles arrow keys for classic controls
          return KeyEventResult.handled;
        },
        child: Center(
          child: isGameStarted
              ? GestureDetector(
                  onPanEnd: (details) {
                    final velocity = details.velocity.pixelsPerSecond;
                    if (velocity.dx.abs() > velocity.dy.abs()) {
                      gameLogic.changeDirection(velocity.dx > 0 ? Direction.right : Direction.left);
                    } else {
                      gameLogic.changeDirection(velocity.dy > 0 ? Direction.down : Direction.up);
                    }
                  },
                  child: Container(
                    width: columns * pixelSize,
                    height: rows * pixelSize,
                    color: const Color.fromARGB(104, 98, 145, 12),
                    child: Stack(
                      children: [
                        for (int y = 0; y < rows; y++)
                          for (int x = 0; x < columns; x++)
                            Grass(
                              blockSize: pixelSize,
                              x: x,
                              y: y,
                              isHidden: gameLogic.snake.contains(Point(x, y)) || gameLogic.food == Point(x, y),
                            ),
                        Food(blockSize: pixelSize, x: gameLogic.food.x, y: gameLogic.food.y),
                        ...gameLogic.snake.map((pos) => SnakeSegment(
                          gameLogic: gameLogic,
                          blockSize: pixelSize,
                          x: pos.x,
                          y: pos.y,
                          isHead: pos == gameLogic.snake.first,
                        )),
                      ],
                    ),
                  ),
                )
              : ElevatedButton(onPressed: _startGame, child: const Text('Start Game')),
        ),
      ),
    );
  }
}
