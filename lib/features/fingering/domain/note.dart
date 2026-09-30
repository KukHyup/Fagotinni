/// Pitch classes, in scientific pitch notation without octave.
///
/// Bassoon note names are **flat-based**: the instrument's lowest note is B♭1,
/// so [label] uses flat spellings by default. Sharps are kept for cases where
/// that reads better.
enum PitchClass {
  c(0, 'C', 'C'),
  cs(1, 'C♯', 'D♭'),
  d(2, 'D', 'D'),
  ds(3, 'D♯', 'E♭'),
  e(4, 'E', 'E'),
  f(5, 'F', 'F'),
  fs(6, 'F♯', 'G♭'),
  g(7, 'G', 'G'),
  gs(8, 'G♯', 'A♭'),
  a(9, 'A', 'A'),
  as(10, 'A♯', 'B♭'),
  b(11, 'B', 'B');

  const PitchClass(this.semitonesFromC, this.sharpLabel, this.flatLabel);

  final int semitonesFromC;

  /// Default display label — flat spelling, as written for bassoon.
  String get label => flatLabel;

  String get sharpName => sharpLabel;

  String get flatName => flatLabel;

  static PitchClass fromMidi(int midi) => PitchClass.values[(midi - 60) % 12];
}

/// A note with an octave, e.g. `ScoredNote(PitchClass.b, 2)` = B♭2.
class ScoredNote implements Comparable<ScoredNote> {
  const ScoredNote(this.pitchClass, this.octave);

  final PitchClass pitchClass;

  /// Scientific pitch notation: middle C is octave 4.
  final int octave;

  int get midi => (octave + 1) * 12 + pitchClass.semitonesFromC;

  /// Display label, e.g. `B♭2`.
  String get label => '${pitchClass.label}$octave';

  @override
  int compareTo(ScoredNote other) => midi.compareTo(other.midi);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoredNote &&
          other.pitchClass == pitchClass &&
          other.octave == octave;

  @override
  int get hashCode => Object.hash(pitchClass, octave);

  @override
  String toString() => label;
}

/// Gameplay modifier that decides *which* fingerings are offered.
///
/// On bassoon the full ("basic") fingering of a note is usually the most
/// complex one, because it gives the best sound. A trill needs to alternate
/// notes fast, so players use the *simpler* alternate fingering instead — hence
/// a note typically has 2–3 variations: one basic plus one or two trills.
enum FingeringMode {
  /// The full fingering: all keys that must be held for the best tone.
  basic,

  /// An alternate, simpler fingering used to execute trills.
  trill;

  String get label => switch (this) {
    FingeringMode.basic => 'Basic',
    FingeringMode.trill => 'Trill',
  };
}