import 'package:flutter/material.dart';
import 'dart:math' as math;

class Food extends StatelessWidget {
  final double blockSize;
  final int x;
  final int y;
  final int snakeX;
  final int snakeY;

  const Food({
    super.key,
    required this.blockSize,
    required this.x,
    required this.y,
    required this.snakeX,
    required this.snakeY,
  });

  @override
  Widget build(BuildContext context) {
    double angle = math.atan2(snakeY - y, snakeX - x);

    return Positioned(
      left: x * blockSize,
      top: y * blockSize,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: blockSize,
          height: blockSize,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: Image.network(
            'https://media.tenor.com/AdhmRK5AoE4AAAAi/ugly-rat.gif', // Pfad zum Bild
            width: blockSize, // Bildgröße
            height: blockSize,
            fit: BoxFit.cover, // Bildgröße anpassen
          ),
        ),
      ),
    );
  }
}