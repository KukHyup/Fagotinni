import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:fagotinni/features/metronome/click_wav.dart';

class MetronomeController extends ChangeNotifier {
  MetronomeController() {
    _loadSounds();
  }

  final AudioPlayer _player = AudioPlayer();
  late final Uint8List _tickBytes;
  late final Uint8List _accentBytes;

  int bpm = 80;
  int beatsPerBar = 4;
  int beat = 0;
  bool running = false;
  Timer? _timer;

  void _loadSounds() {
    _tickBytes = buildClickWav(frequency: 980);
    _accentBytes = buildClickWav(frequency: 1480, milliseconds: 55);
  }

  void setBpm(int value) {
    bpm = value.clamp(40, 240);
    if (running) {
      _restartTimer();
    }
    notifyListeners();
  }

  void setBeatsPerBar(int value) {
    beatsPerBar = value;
    beat = 0;
    notifyListeners();
  }

  Future<void> start() async {
    if (running) return;
    running = true;
    beat = 0;
    notifyListeners();
    await _click();
    if (running) {
      _restartTimer();
    }
  }

  Future<void> stop() async {
    if (!running) return;
    running = false;
    _timer?.cancel();
    beat = 0;
    notifyListeners();
    await _player.stop();
  }

  void _restartTimer() {
    _timer?.cancel();
    final interval = Duration(milliseconds: (60000 / bpm).round());
    _timer = Timer.periodic(interval, (_) => _click());
  }

  Future<void> _click() async {
    if (!running) return;
    final isAccent = beat == 0;
    notifyListeners();
    beat = (beat + 1) % beatsPerBar;
    try {
      await _player.stop();
      await _player.play(
        BytesSource(isAccent ? _accentBytes : _tickBytes, mimeType: 'audio/wav'),
      );
    } catch (_) {
      // Audio may be unavailable on some desktops; visuals still pulse.
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
