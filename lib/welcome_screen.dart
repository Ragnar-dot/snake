import 'package:flutter/material.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);

    // Load the GIF and start the animation after it's loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gifController.repeat(
        min: 0,
        max: 29, // Replace 29 with the total number of frames - 1
        period: Duration(seconds: 10),
      );
    });
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GifImage(
              controller: _gifController,
              image: AssetImage('assets/videos/snake.gif'),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _gifController.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text('Start Game'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}