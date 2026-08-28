import 'dart:math';
import 'dart:typed_data';

class PitchEstimate {
  const PitchEstimate({required this.frequencyHz});

  final double frequencyHz;

  String get noteName {
    const names = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    return names[_midi % 12];
  }

  int get octave => (_midi ~/ 12) - 1;

  /// Deviation from equal temperament in cents. Negative = flat.
  double get cents {
    final midiExact = 69 + 12 * (log(frequencyHz / 440) / ln2);
    return (midiExact - _midi) * 100;
  }

  int get _midi => (69 + 12 * (log(frequencyHz / 440) / ln2)).round();
}

/// YIN-style detector for a sustained woodwind tone.
class PitchDetector {
  PitchEstimate? detect(Uint8List pcm16le, {required int sampleRate}) {
    final count = pcm16le.length ~/ 2;
    if (count < 2048) return null;

    final samples = Float64List(count);
    var rms = 0.0;
    final data = ByteData.sublistView(pcm16le);
    for (var i = 0; i < count; i++) {
      final v = data.getInt16(i * 2, Endian.little) / 32768.0;
      samples[i] = v;
      rms += v * v;
    }
    rms = sqrt(rms / count);
    if (rms < 0.01) return null;

    final tauMin = max(2, (sampleRate / 1200).floor());
    final tauMax = min((sampleRate / 70).floor(), count ~/ 2);
    final yinSize = tauMax + 1;
    final diff = Float64List(yinSize);
    final window = min(count - tauMax, 2048);

    for (var tau = 1; tau < yinSize; tau++) {
      var sum = 0.0;
      for (var i = 0; i < window; i++) {
        final delta = samples[i] - samples[i + tau];
        sum += delta * delta;
      }
      diff[tau] = sum;
    }

    final cmnd = Float64List(yinSize);
    cmnd[0] = 1;
    var running = 0.0;
    for (var tau = 1; tau < yinSize; tau++) {
      running += diff[tau];
      cmnd[tau] = diff[tau] * tau / running;
    }

    const threshold = 0.15;
    var tauEstimate = -1;
    for (var tau = tauMin; tau < tauMax; tau++) {
      if (cmnd[tau] < threshold) {
        while (tau + 1 < tauMax && cmnd[tau + 1] < cmnd[tau]) {
          tau++;
        }
        tauEstimate = tau;
        break;
      }
    }
    if (tauEstimate < 0) {
      var best = 1.0;
      for (var tau = tauMin; tau < tauMax; tau++) {
        if (cmnd[tau] < best) {
          best = cmnd[tau];
          tauEstimate = tau;
        }
      }
      if (best > 0.4) return null;
    }

    final tau = _parabolic(cmnd, tauEstimate);
    if (tau <= 0) return null;
    final frequency = sampleRate / tau;
    if (frequency < 70 || frequency > 1200) return null;
    return PitchEstimate(frequencyHz: frequency);
  }

  double _parabolic(Float64List values, int index) {
    if (index <= 0 || index >= values.length - 1) return index.toDouble();
    final s0 = values[index - 1];
    final s1 = values[index];
    final s2 = values[index + 1];
    final denom = 2 * s1 - s2 - s0;
    if (denom.abs() < 1e-12) return index.toDouble();
    return index + (s0 - s2) / (2 * denom);
  }
}
