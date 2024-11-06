// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Spiel',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: GameScreen(), // Startet automatisch das Spiel
      debugShowCheckedModeBanner: false,
    );
  }
}
