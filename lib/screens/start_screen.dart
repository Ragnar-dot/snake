import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> bestScores = [];

  @override
  void initState() {
    super.initState();
    _loadBestScores();
  }

  Future<void> _loadBestScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('bestScores') ?? [];
    setState(() {
      bestScores = scores
          .map((score) {
            final parts = score.split('|');
            return {'name': parts[0], 'score': int.parse(parts[1])};
          })
          .toList();
    });
  }

  Future<void> _saveScore(String name, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList('bestScores') ?? [];
    scores.add('$name|$score');
    scores.sort((a, b) => int.parse(b.split('|')[1]) - int.parse(a.split('|')[1]));
    if (scores.length > 10) scores.removeLast();
    await prefs.setStringList('bestScores', scores);
    setState(() {
      _loadBestScores();
    });
  }

  void _startGame() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          playerName: _nameController.text,
          onGameEnd: (score) {
            _saveScore(_nameController.text, score);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Serpent Hall',
          style: GoogleFonts.carterOne(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 140, 36), // Green AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter thy name to awaken the serpent!',
              style: GoogleFonts.carterOne(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Player Name',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Summon the Serpent’s Hunger',
                style: GoogleFonts.rubikWetPaint(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Legends of the Serpent',
              style: GoogleFonts.rubikWetPaint(
                fontSize: 24,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: bestScores.length,
                itemBuilder: (context, index) {
                  final score = bestScores[index];
                  return ListTile(
                    title: Text(
                      score['name'],
                      style: const TextStyle(color: Colors.green),
                    ),
                    trailing: Text(
                      score['score'].toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}