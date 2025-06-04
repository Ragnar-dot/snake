import 'dart:io';

import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper plugin initialization

  if (Platform.isWindows) {
    setWindowTitle("Snake Game");
    setWindowFrame(const Rect.fromLTWH(300, 300, 900, 800)); // Fenstergröße und Position
  }

  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Spiel',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const WelcomeScreen(), // Startet den Begrüßungsbildschirm
      debugShowCheckedModeBanner: false,
    );
  }
}