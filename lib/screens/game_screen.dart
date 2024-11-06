// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/game_logic.dart';
import '../models/direction.dart';
import '../widgets/snake_segment.dart';
import '../widgets/food.dart';
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
  bool isGameLogicInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startGame());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isGameLogicInitialized) {
      pixelSize = 50.0; // Fester Wert für Testzwecke
      gameLogic = GameLogic(
        rows: rows,
        columns: columns,
        
        soundManager: soundManager,
      );
      isGameLogicInitialized = true;
    }
  }

  @override
  void dispose() {
    gameLogic.timer?.cancel();
    soundManager.dispose();
    super.dispose();
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
        title: const Text('Spiel beendet!'),
        content: Text('Deine Punktzahl: ${gameLogic.score}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Neustarten'),
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

  void _onSwipe(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    if (velocity.dx.abs() > velocity.dy.abs()) {
      if (velocity.dx > 0 && gameLogic.currentDirection != Direction.left) {
        gameLogic.changeDirection(Direction.right);
      } else if (velocity.dx < 0 && gameLogic.currentDirection != Direction.right) {
        gameLogic.changeDirection(Direction.left);
      }
    } else {
      if (velocity.dy > 0 && gameLogic.currentDirection != Direction.up) {
        gameLogic.changeDirection(Direction.down);
      } else if (velocity.dy < 0 && gameLogic.currentDirection != Direction.down) {
        gameLogic.changeDirection(Direction.up);
      }
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          if (gameLogic.currentDirection != Direction.down) {
            gameLogic.changeDirection(Direction.up);
          }
          break;
        case LogicalKeyboardKey.arrowDown:
          if (gameLogic.currentDirection != Direction.up) {
            gameLogic.changeDirection(Direction.down);
          }
          break;
        case LogicalKeyboardKey.arrowLeft:
          if (gameLogic.currentDirection != Direction.right) {
            gameLogic.changeDirection(Direction.left);
          }
          break;
        case LogicalKeyboardKey.arrowRight:
          if (gameLogic.currentDirection != Direction.left) {
            gameLogic.changeDirection(Direction.right);
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isGameStarted ? 'Snake Spiel - Punktzahl: ${gameLogic.score}' : 'Snake Spiel'),
      ),
      body: Focus(
        autofocus: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          _handleKeyEvent(event);
          return KeyEventResult.handled;
        },
        child: Center(
          child: isGameStarted
              ? GestureDetector(
                  onPanEnd: _onSwipe,
                  child: Container(
                    width: columns * pixelSize,
                    height: rows * pixelSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey[300],
                    ),
                    child: Stack(
                      children: [
                        Food(
                          blockSize: pixelSize,
                          x: gameLogic.food.dx.toInt(), // Konvertierung zu int
                          y: gameLogic.food.dy.toInt(), // Konvertierung zu int
                        ),
                        ...gameLogic.snake.map((pos) {
                          return SnakeSegment(
                            gameLogic: gameLogic,
                            blockSize: pixelSize,
                            x: pos.dx.toInt(), // Konvertierung zu int
                            y: pos.dy.toInt(), // Konvertierung zu int
                            isHead: pos == gameLogic.snake.first,
                          );
                        }),
                      ],
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Spiel starten'),
                ),
        ),
      ),
    );
  }
}
