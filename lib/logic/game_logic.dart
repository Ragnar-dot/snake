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
  Point<int> food = const Point(30, 30);
  Set<Point<int>> forbiddenBlocks = {}; // Blocks removed from the field
  Timer? timer;
  double gameSpeed = 150; // Milliseconds
  bool isGameOver = false;
  int score = 0;
  int lives = 3; // Snake lives

  GameLogic({
    required this.rows,
    required this.columns,
    required this.soundManager,
  });

  void start(Function onUpdate, Function onGameOver) {
    generateFood();
    timer = Timer.periodic(Duration(milliseconds: gameSpeed.toInt()), (timer) {
      update(onUpdate, onGameOver);
    });
  }

  void update(Function onUpdate, Function onGameOver) {
    if (isGameOver) return;

    Point<int> head = snake.first;
    Point<int> newHead;

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

    if (newHead.x < 0 ||
        newHead.y < 0 ||
        newHead.x >= columns ||
        newHead.y >= rows ||
        snake.contains(newHead) ||
        forbiddenBlocks.contains(newHead)) {
      if (lives > 1) {
        lives--;
        resetSnakePosition(); // Reset snake's position
        soundManager.playSound('lost_life.mp3', 0.5);
      } else {
        gameOver(onGameOver);
      }
      return;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score += 10;
      soundManager.playSound('eat.mp3', 0.7);
      soundManager.playSound('eat2.mp3', 0.2);
      soundManager.playSound('hissing.mp3', 0.6);
      generateFood();

      if (score >= 100 && score % 30 == 0) {
        addForbiddenBlock(); // Add a forbidden block every 30 points after 100
      }

      if (score % 50 == 0 && gameSpeed > 100) {
        timer?.cancel();
        gameSpeed -= 50;
        start(onUpdate, onGameOver);
      }
    } else {
      snake.removeLast();
    }

    onUpdate();
  }

  void generateFood() {
    Random rand = Random();
    Point<int> newFood;
    do {
      newFood = Point(rand.nextInt(columns), rand.nextInt(rows));
    } while (snake.contains(newFood) || forbiddenBlocks.contains(newFood));
    food = newFood;
  }

  void addForbiddenBlock() {
    Random rand = Random();
    Point<int> blockToRemove;
    do {
      blockToRemove = Point(rand.nextInt(columns), rand.nextInt(rows));
    } while (snake.contains(blockToRemove) || blockToRemove == food || forbiddenBlocks.contains(blockToRemove));
    forbiddenBlocks.add(blockToRemove);
  }

  void resetSnakePosition() {
    // Reset the snake to the center of the field
    snake = [Point((columns ~/ 2), (rows ~/ 2))];
    currentDirection = Direction.right;
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
    gameSpeed = 150;
    lives = 3; // Reset lives
    forbiddenBlocks.clear(); // Reset forbidden blocks
    timer?.cancel();
  }

  Point<int> getSnakeHeadPosition() => snake.first;
}