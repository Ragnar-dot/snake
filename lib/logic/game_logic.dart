import 'dart:async';
import 'dart:math';

import '../models/direction.dart';
import '../services/sound_manager.dart';

class GameLogic {
  final int rows;
  final int columns;
  final SoundManager soundManager;

  Direction currentDirection = Direction.right;
  List<Point<int>> snake = [const Point(10, 10)];
  Point<int> food = const Point(15, 15);
  Timer? timer;
  double gameSpeed = 200; // Milliseconds
  bool isGameOver = false;
  int score = 0;

  GameLogic({
    required this.rows,
    required this.columns,
    required this.soundManager,
  });

  void start(Function onUpdate, Function onGameOver) {
    timer = Timer.periodic(Duration(milliseconds: gameSpeed.toInt()), (timer) {
      update(onUpdate, onGameOver);
    });
  }

  void update(Function onUpdate, Function onGameOver) {
    if (isGameOver) return;

    // Current head position
    Point<int> head = snake.first;
    Point<int> newHead;

    // Update position based on the direction
    switch (currentDirection) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Collision checks
    if (newHead.x < 0 || newHead.y < 0 || newHead.x >= columns || newHead.y >= rows || snake.contains(newHead)) {
      gameOver(onGameOver);
      return;
    }

    snake.insert(0, newHead); // Add new head at the front

    if (newHead == food) {
      score += 10;
      soundManager.playSound('eat.mp3', 0.6);
      soundManager.playSound('eat2.mp3', 0.1);
      soundManager.playSound('hissing.mp3', 0.4); 
      generateFood();
      if (score % 50 == 0 && gameSpeed > 100) {
        timer?.cancel();
        gameSpeed -= 50;
        start(onUpdate, onGameOver);
      }
    } else {
      snake.removeLast(); // Move the tail by removing the last segment
    }

    onUpdate();
  }

  void generateFood() {
    Random rand = Random();
    Point<int> newFood;
    do {
      newFood = Point(rand.nextInt(columns), rand.nextInt(rows));
    } while (snake.contains(newFood));
    food = newFood;
  }

  void changeDirection(Direction newDirection) {
    if (newDirection != {
      Direction.up: Direction.down,
      Direction.down: Direction.up,
      Direction.left: Direction.right,
      Direction.right: Direction.left,
    }[currentDirection]) {
      currentDirection = newDirection;
    }
  }

  void gameOver(Function onGameOver) {
    timer?.cancel();
    isGameOver = true;
    soundManager.playSound('game_over.mp3', 0.1);
    onGameOver();
  }

  void reset() {
    snake = [const Point(10, 10)];
    currentDirection = Direction.right;
    generateFood();
    isGameOver = false;
    score = 0;
    gameSpeed = 200;
    timer?.cancel();
  }
}
