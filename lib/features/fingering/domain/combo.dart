/// All possible bassoon combo types.
///
/// A combo is a playing technique — a way to execute a transition between
/// two notes. Each combo has a basic technique and one or more variations.
///
/// The enum is the single source of truth for which combos exist. The actual
/// fingerings live in `techniques/<technique_name>/`.
enum Combo {
  /// Shake — rapid alternation between two notes.
  shake,

  /// Trill — rapid alternation between two notes a second apart.
  trill,

  /// Whisper key on — whisper key is held down.
  wKeyOn,

  /// Whisper key off — whisper key is not held down.
  wKeyOff,

  /// Very fast — a simplified fingering for rapid passages.
  veryFast,

  /// No D♭ key — a fingering that avoids the D♭ key.
  noDflatKey,
}

/// Extension to get the display name for each combo.
extension ComboInfo on Combo {
  /// Display name, e.g. "Shake".
  String get displayName => switch (this) {
    Combo.shake => 'Shake',
    Combo.trill => 'Trill',
    Combo.wKeyOn => 'Whisper Key On',
    Combo.wKeyOff => 'Whisper Key Off',
    Combo.veryFast => 'Very Fast',
    Combo.noDflatKey => 'No D♭ Key',
  };

  /// File prefix for variations of this combo, e.g. "shake_v1".
  String get filePrefix => switch (this) {
    Combo.shake => 'shake',
    Combo.trill => 'trill',
    Combo.wKeyOn => 'wkeyon',
    Combo.wKeyOff => 'wkeyoff',
    Combo.veryFast => 'veryfast',
    Combo.noDflatKey => 'nodflatkey',
  };
}