import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final List<AudioPlayer> _players = [];

  Future<void> playSound(String sound, {double volume = 1.0}) async {
    // Erstelle für jeden Sound eine neue AudioPlayer-Instanz
    AudioPlayer player = AudioPlayer();
    _players.add(player);

    // Setze Lautstärke und spiele den Sound ab
    await player.setVolume(volume);
    await player.setSource(AssetSource('sounds/$sound'));
    await player.resume();

    // Entferne den Player aus der Liste, sobald der Sound fertig ist
    player.onPlayerComplete.listen((_) {
      _players.remove(player);
      player.dispose();
    });
  }

  void dispose() {
    // Dispose aller AudioPlayer-Instanzen
    for (var player in _players) {
      player.dispose();
    }
    _players.clear();
  }
}
