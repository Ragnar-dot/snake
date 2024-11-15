import 'package:flutter/material.dart';
import 'package:snake/screens/start_screen.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';

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
      try {
        gifController.repeat(
          min: 0,
          max: gifController.upperBound,
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
                    MaterialPageRoute(builder: (context) => const StartScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 175, 76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                ),
                child: Text(
                  'Awaken the Serpent',
                  style: GoogleFonts.rubikWetPaint(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 255, 255, 255), // White color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}