import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:fagotinni/features/tuner/pitch_detector.dart';

enum TunerPermission { unknown, granted, denied, permanentlyDenied }

class TunerController extends ChangeNotifier {
  TunerController();

  final AudioRecorder _recorder = AudioRecorder();
  final PitchDetector _detector = PitchDetector();
  StreamSubscription<Uint8List>? _subscription;

  TunerPermission permission = TunerPermission.unknown;
  bool listening = false;
  PitchEstimate? estimate;
  String? errorMessage;

  static const sampleRate = 44100;

  Future<void> init() async {
    try {
      if (kIsWeb) {
        permission = TunerPermission.granted;
        notifyListeners();
        return;
      }
      final status = await Permission.microphone.status;
      permission = _map(status);
      notifyListeners();
    } catch (_) {
      permission = TunerPermission.denied;
      notifyListeners();
    }
  }

  Future<void> requestPermission() async {
    try {
      if (kIsWeb) {
        permission = TunerPermission.granted;
        notifyListeners();
        return;
      }
      final status = await Permission.microphone.request();
      permission = _map(status);
      notifyListeners();
    } catch (_) {
      permission = TunerPermission.denied;
      notifyListeners();
    }
  }

  TunerPermission _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited) return TunerPermission.granted;
    if (status.isPermanentlyDenied) return TunerPermission.permanentlyDenied;
    return TunerPermission.denied;
  }

  Future<void> start() async {
    if (listening) return;
    if (permission != TunerPermission.granted) {
      await requestPermission();
      if (permission != TunerPermission.granted) return;
    }

    final hasMic = await _recorder.hasPermission();
    if (!hasMic) {
      permission = TunerPermission.denied;
      notifyListeners();
      return;
    }

    try {
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
        ),
      );
      listening = true;
      notifyListeners();
      final buffer = BytesBuilder(copy: false);
      _subscription = stream.listen((chunk) {
        buffer.add(chunk);
        if (buffer.length < 4096) return;
        final bytes = buffer.takeBytes();
        final found = _detector.detect(bytes, sampleRate: sampleRate);
        if (found != null) {
          estimate = found;
          notifyListeners();
        }
      });
    } catch (error) {
      errorMessage = error.toString();
      listening = false;
      notifyListeners();
    }
  }

  Future<void> stop() async {
    listening = false;
    await _subscription?.cancel();
    _subscription = null;
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(stop());
    _recorder.dispose();
    super.dispose();
  }
}
