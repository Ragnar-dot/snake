import 'package:flutter/material.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:gif/gif.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late GifController gifController;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);

    // Start the GIF animation after the widget is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        gifController.repeat(
          min: 0,
          max: 20, // Try with 20 as a safe frame count. Adjust as needed.
          period: Duration(seconds: 100),
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
              image: AssetImage('assets/videos/snake.gif'),
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
                  gifController.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text('Start Game Snake'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}