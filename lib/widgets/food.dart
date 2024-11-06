// lib/widgets/food.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  final double blockSize;
  final int x;
  final int y;

  const Food({super.key, 
    required this.blockSize,
    required this.x,
    required this.y,
  });

@override
Widget build(BuildContext context) {
  return Positioned(
    left: x * blockSize,
    top: y * blockSize,
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
        color: Colors.red, // Optional: Bildfarbe, wenn du einen Farbfilter anwenden möchtest
        colorBlendMode: BlendMode.modulate, // Modus für den Farbfilter
      ),
    ),
  );
}
}
