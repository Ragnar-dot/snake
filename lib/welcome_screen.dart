import 'package:flutter/material.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:gif/gif.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late GifController gifController;

@override
void initState() {
  super.initState();
  gifController = GifController(vsync: this);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    print("Controller bounds: lower=${gifController.lowerBound}, upper=${gifController.upperBound}");
    try {
      gifController.repeat(
        min: gifController.lowerBound, // Ensure min is within bounds
        max: gifController.upperBound, // Ensure max matches the bounds
        period: const Duration(seconds: 5),
      );
    } catch (e) {
      print("Error starting GIF animation: $e");
    }
  });
}

  @override
  void dispose() {
    gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Gif(
              controller: gifController,
              image: const AssetImage('assets/videos/snake.gif'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                ),
                child: const Text(
                  'Take a Bite',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}