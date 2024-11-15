// lib/main.dart
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Spiel',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: WelcomeScreen(), // Startet den Begrüßungsbildschirm
      debugShowCheckedModeBanner: false,
    );
  }
}