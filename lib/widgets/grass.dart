// lib/widgets/grass.dart

import 'package:flutter/material.dart';

class Grass extends StatelessWidget {
  final double blockSize;
  final int x, y;
  final bool isHidden;

  const Grass({
    Key? key,
    required this.blockSize,
    required this.x,
    required this.y,
    required this.isHidden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x * blockSize,
      top: y * blockSize,
      child: AnimatedOpacity(
        opacity: isHidden ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 600),
        child: Image.network(
          'https://img1.picmix.com/output/stamp/thumb/8/4/3/1/931348_67d20.gif',
          width: blockSize,
          height: blockSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
