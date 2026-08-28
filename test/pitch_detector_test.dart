import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fagotinni/features/tuner/pitch_detector.dart';

Uint8List sinePcm({required double hz, int sampleRate = 44100, int samples = 8192}) {
  final bytes = ByteData(samples * 2);
  for (var i = 0; i < samples; i++) {
    final value = sin(2 * pi * hz * i / sampleRate);
    bytes.setInt16(i * 2, (value * 20000).round(), Endian.little);
  }
  return bytes.buffer.asUint8List();
}

void main() {
  test('detects A4 near 440 Hz', () {
    final detector = PitchDetector();
    final estimate = detector.detect(sinePcm(hz: 440), sampleRate: 44100);
    expect(estimate, isNotNull);
    expect(estimate!.noteName, 'A');
    expect(estimate.frequencyHz, closeTo(440, 8));
  });
}
