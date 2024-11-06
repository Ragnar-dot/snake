import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart'; // Hinzugefügter Import
import '../models/direction.dart';
import '../services/sound_manager.dart';

class GameLogic {
  final int rows;
  final int columns;
  final SoundManager soundManager;

  Direction currentDirection = Direction.right;
  List<Offset> snake = [const Offset(10, 10)];
  Offset food = const Offset(15, 15);
  Timer? timer;
  double gameSpeed = 200; // Millisekunden
  bool isGameOver = false;
  int score = 0;

  GameLogic({required this.rows, required this.columns, required this.soundManager});

  void start(Function onUpdate, Function onGameOver) {
    timer = Timer.periodic(Duration(milliseconds: gameSpeed.toInt()), (timer) {
      update(onUpdate, onGameOver);
    });
  }

  void update(Function onUpdate, Function onGameOver) {
    if (isGameOver) return;

    // Aktuelle Kopfposition
    Offset head = snake.first;

    // Neue Kopfposition basierend auf der Richtung
    Offset newHead;
    switch (currentDirection) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }

    // Kollisionsprüfung mit Wänden
    if (newHead.dx < 0 ||
        newHead.dy < 0 ||
        newHead.dx >= columns ||
        newHead.dy >= rows) {
      gameOver(onGameOver);
      return;
    }

    // Kollisionsprüfung mit sich selbst
    if (snake.contains(newHead)) {
      gameOver(onGameOver);
      return;
    }

    // Hinzufügen der neuen Kopfposition
    snake.insert(0, newHead);

    // Überprüfen, ob die Schlange das Futter erreicht hat
if (newHead == food) {
  score += 10;
  // Beide Sounds gleichzeitig abspielen
  soundManager.playSound('eat.mp3');
  soundManager.playSound('eat2.mp3');
  generateFood();
  // Geschwindigkeit erhöhen alle 50 Punkte (5 Futter)
  if (score % 50 == 0 && gameSpeed > 100) {
    timer?.cancel();
    gameSpeed -= 50;
    start(onUpdate, onGameOver);
  }

    } else {
      // Entfernen des letzten Segments
      snake.removeLast();
    }

    onUpdate();
  }

  void generateFood() {
    Random rand = Random();
    Offset newFood;
    do {
      newFood = Offset(rand.nextInt(columns).toDouble(), rand.nextInt(rows).toDouble());
    } while (snake.contains(newFood));
    food = newFood;
  }


void changeDirection(Direction newDirection) {
  // Vermeidet Richtungswechsel zur entgegengesetzten Richtung
  final oppositeDirections = {
    Direction.up: Direction.down,
    Direction.down: Direction.up,
    Direction.left: Direction.right,
    Direction.right: Direction.left,
  };

  // Prüft, ob der neue Richtungswechsel erlaubt ist
  if (newDirection != oppositeDirections[currentDirection]) {
    currentDirection = newDirection;
  }
}






  void gameOver(Function onGameOver) {
    timer?.cancel();
    isGameOver = true;
    soundManager.playSound('game_over.mp3');
    onGameOver();
  }

  void reset() {
    snake = [const Offset(10, 10)];
    currentDirection = Direction.right;
    generateFood();
    isGameOver = false;
    score = 0;
    gameSpeed = 300;
    timer?.cancel();
  }
}
