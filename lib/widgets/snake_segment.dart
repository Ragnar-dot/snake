import 'package:flutter/material.dart';
import '../models/direction.dart';
import '../logic/game_logic.dart';

class SnakeSegment extends StatelessWidget {
  final double blockSize;
  final int x;
  final int y;
  final bool isHead;
  final bool isTail;
  final GameLogic gameLogic;

  const SnakeSegment({
    Key? key,
    required this.blockSize,
    required this.x,
    required this.y,
    required this.gameLogic,
    this.isHead = false,
    this.isTail = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quarterTurns = 0;

    // Adjust orientation based on snake's current direction
    switch (gameLogic.currentDirection) {
      case Direction.up:
        quarterTurns = 2;
        break;
      case Direction.right:
        quarterTurns = 3;
        break;
      case Direction.down:
        quarterTurns = 0;
        break;
      case Direction.left:
        quarterTurns = 1;
        break;
    }

    return Positioned(
      left: x * blockSize,
      top: y * blockSize,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Container(
          width: blockSize,
          height: blockSize,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: isHead
                ? const DecorationImage(
                    image: NetworkImage(
                      'https://preview.redd.it/4ntn4a5zitq91.png?auto=webp&s=99ac3b9c661becf92590b87e5ba02753d45d9032',
                    ),
                    fit: BoxFit.cover,
                  )
                : isTail
                    ? const DecorationImage(
                        image: AssetImage(
                          'assets/sounds/tail.png', 
                        ),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage(
                          "https://img.freepik.com/premium-vector/abstract-pattern-design-fabric-cloth-patterngreen-background-with-patternsreptile-skin-seaml_1049145-245.jpg?semt=ais_hybrid",
                        ),
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      ),
    );
  }
}
