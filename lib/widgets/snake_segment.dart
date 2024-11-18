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
    super.key,
    required this.blockSize,
    required this.x,
    required this.y,
    required this.gameLogic,
    this.isHead = false,
    this.isTail = false,
  });

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

    // Offset to create slight overlap
    const double overlapOffset = 1.0;

    return Positioned(
      left: x * blockSize - (isHead ? 0 : overlapOffset),
      top: y * blockSize - (isHead ? 0 : overlapOffset),
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Container(
          width: blockSize + (isHead ? 0 : overlapOffset * 4),
          height: blockSize + (isHead ? 0 : overlapOffset * 4),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            image: isHead
                ? DecorationImage(
                        image: AssetImage(
                                    'assets/sounds/snakeHead.png',
                                  ),
                        fit: BoxFit.cover,
                    //fit: BoxFit.cover,
                  )
                : isTail
                    ? const DecorationImage(
                        image: AssetImage(
                          'assets/sounds/tail.png',  // tail 
                        ),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage(
                          "https://img.freepik.com/premium-vector/abstract-pattern-design-fabric-cloth-patterngreen-background-with-patternsreptile-skin-seaml_1049145-245.jpg?semt=ais_hybrid", // body
                        ),
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      ),
    );
  }
}