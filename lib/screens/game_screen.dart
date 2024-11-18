import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../logic/game_logic.dart';
import '../models/direction.dart';
import '../widgets/snake_segment.dart';
import '../widgets/food.dart';
import '../widgets/grass.dart';
import '../services/sound_manager.dart';

class GameScreen extends StatefulWidget {
  final String playerName; // Add player name parameter
  final Function(int score) onGameEnd; // Callback to handle game end

  const GameScreen({
    Key? key,
    required this.playerName,
    required this.onGameEnd,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int rows = 0;
  int columns = 0;
  double pixelSize = 25.0;
  GameLogic? gameLogic;
  final SoundManager soundManager = SoundManager();
  bool isGameStarted = false;
  bool isMusicPlaying = true;

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const double padding = 40.0;
  static const double appBarHeight = 160.0;
  static const Color backgroundColor = Color.fromARGB(104, 98, 145, 12);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGameSettings();
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  void _initializeGameSettings() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableWidth = screenWidth - padding;
    final availableHeight = screenHeight - appBarHeight;

    setState(() {
      rows = (availableHeight / pixelSize).floor().clamp(10, 40);
      columns = (availableWidth / pixelSize).floor().clamp(10, 40);
      gameLogic = GameLogic(
        rows: rows,
        columns: columns,
        soundManager: soundManager,
      );
    });
  }

  void _startGame() async {
    if (gameLogic == null) return;
    setState(() {
      isGameStarted = true;
      gameLogic!.start(_updateUI, _onGameOver);
    });
    if (isMusicPlaying) {
      await _audioPlayer.play(
        AssetSource('sounds/background_music.mp3'),
        volume: 0.5,
      );
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    }
  }

  void _updateUI() {
    setState(() {});
  }

  void _onGameOver() async {
    setState(() {
      isGameStarted = false;
    });
    await _audioPlayer.stop();
    widget.onGameEnd(gameLogic?.score ?? 0); // Pass score to callback
    _showGameOverDialog();
  }

void _showGameOverDialog() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black87, // Dark background for a sad tone
      title: Text(
        'Fate Has Spoken!',
        style: TextStyle(
          fontFamily: 'CarterOne', // Use Gothic or suitable font
          fontSize: 24,
          color: Colors.red[300],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.playerName}, thy journey ends here.',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Thy score: ${gameLogic?.score ?? 0}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _restartGame();
          },
          child: const Text(
            'Awaken Once More',
            style: TextStyle(
              fontFamily: 'CarterOne',
              fontSize: 16,
              color: Colors.redAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pop(context); // Return to Start Screen
          },
          child: Text(
            'Return to the Hall',
            style: TextStyle(
              fontFamily: 'CarterOne',
              fontSize: 16,
              color: Colors.blueGrey[300],
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

  void _restartGame() {
    setState(() {
      gameLogic?.reset();
      _startGame();
    });
  }

  void _toggleMusic() async {
    if (isMusicPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isMusicPlaying = !isMusicPlaying;
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          gameLogic?.changeDirection(Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
          gameLogic?.changeDirection(Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
          gameLogic?.changeDirection(Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
          gameLogic?.changeDirection(Direction.right);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game - ${widget.playerName}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isMusicPlaying ? Icons.volume_up : Icons.volume_off,
            ),
            onPressed: _toggleMusic,
          ),
        ],
      ),
      body: Focus(
        autofocus: true,
        onKey: (FocusNode node, RawKeyEvent event) {
          _handleKeyEvent(event);
          return KeyEventResult.handled;
        },
        child: Column(
          children: [
            _buildScoreAndLivesDisplay(),
            if (gameLogic != null)
              _buildGameArea()
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreAndLivesDisplay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Score: ${gameLogic?.score ?? 0}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Row(
            children: List.generate(
              gameLogic?.lives ?? 0,
              (index) => const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildGameArea() {
  return Expanded(
    child: Center(
      child: isGameStarted
          ? GestureDetector(
              onPanEnd: (details) {
                final velocity = details.velocity.pixelsPerSecond;
                if (velocity.dx.abs() > velocity.dy.abs()) {
                  gameLogic?.changeDirection(
                      velocity.dx > 0 ? Direction.right : Direction.left);
                } else {
                  gameLogic?.changeDirection(
                      velocity.dy > 0 ? Direction.down : Direction.up);
                }
              },
              child: Container(
                width: columns * pixelSize,
                height: rows * pixelSize,
                color: const Color.fromARGB(104, 124, 155, 66),
                child: Stack(
                  children: [
                    // Render grass blocks
                    for (int y = 0; y < rows; y++)
                      for (int x = 0; x < columns; x++)
                        Grass(
                          blockSize: pixelSize,
                          x: x,
                          y: y,
                          isHidden:
                              gameLogic?.snake.contains(Point(x, y)) ?? false,
                        ),
                    // Render forbidden blocks as images
                    for (final block in gameLogic?.forbiddenBlocks ?? {})
                      Positioned(
                        left: block.x * pixelSize,
                        top: block.y * pixelSize,
                        child: Container(
                          width: pixelSize,
                          height: pixelSize,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 120, 175, 76),
                          ),
                          child: Image.asset(
                            'assets/sounds/stone.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    // Render food
                    Food(
                      blockSize: pixelSize,
                      x: gameLogic?.food.x ?? 0,
                      y: gameLogic?.food.y ?? 0,
                      snakeX: gameLogic?.snake.first.x ?? 0,
                      snakeY: gameLogic?.snake.first.y ?? 0,
                    ),
                    // Render snake segments
                    ...?gameLogic?.snake.asMap().entries.map((entry) {
                      final index = entry.key;
                      final pos = entry.value;
                      return SnakeSegment(
                        gameLogic: gameLogic!,
                        blockSize: pixelSize,
                        x: pos.x,
                        y: pos.y,
                        isHead: index == 0,
                        isTail: index == gameLogic!.snake.length - 1,
                      );
                    }),
                  ],
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
              ),
              child: const Text(
                'Summon the Serpent’s Hunger',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
    ),
  );
}
}