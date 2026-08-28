import 'dart:math';
import 'dart:typed_data';

Uint8List buildClickWav({required double frequency, int milliseconds = 45}) {
  const sampleRate = 44100;
  final count = (sampleRate * milliseconds / 1000).round();
  final samples = Int16List(count);
  for (var i = 0; i < count; i++) {
    final t = i / sampleRate;
    final envelope = exp(-t * 48);
    final value = sin(2 * pi * frequency * t) * envelope;
    samples[i] = (value * 30000).round().clamp(-32767, 32767);
  }

  final dataSize = samples.length * 2;
  final bytes = BytesBuilder();
  void writeString(String value) => bytes.add(value.codeUnits);
  void write32(int value) {
    bytes.add([
      value & 0xff,
      (value >> 8) & 0xff,
      (value >> 16) & 0xff,
      (value >> 24) & 0xff,
    ]);
  }

  void write16(int value) {
    bytes.add([value & 0xff, (value >> 8) & 0xff]);
  }

  writeString('RIFF');
  write32(36 + dataSize);
  writeString('WAVE');
  writeString('fmt ');
  write32(16);
  write16(1);
  write16(1);
  write32(sampleRate);
  write32(sampleRate * 2);
  write16(2);
  write16(16);
  writeString('data');
  write32(dataSize);
  bytes.add(samples.buffer.asUint8List());
  return bytes.toBytes();
}
