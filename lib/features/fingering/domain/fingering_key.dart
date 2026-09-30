/// Physical keys of the Heckel-system bassoon — padded keys pressed by
/// fingers to cover tone holes.
///
/// 25 unique keys. The [bitIndex] of each key is its number on the reference
/// bassoon key diagram (1-25), so no separate mapping is needed.
///
/// Open tone holes (A, B, D, E) are NOT keys — see [BassoonHole].
enum BassoonKey {
  // --- Left thumb (8) ---
  lowBflat(1),    // #1  — Low B♭ key
  lowB(2),        // #2  — Low B key
  lowC(3),        // #3  — Low C key
  lowD(4),        // #4  — Low D key
  whisperKey(5),  // #5  — Whisper key
  thumbCsharp(6), // #6  — High C♯ key
  highA(7),       // #7  — High A key
  highC(8),       // #8  — High C key
  highD(9),       // #9  — High D key

  // --- Right thumb (5) ---
  thumbBflat(10),   // #10 — Thumb B♭ key
  lowE(11),        // #11 — Low E key
  thumbFsharp(12), // #12 — Thumb F♯ key
  thumbAflat(13),   // #13 — Thumb A♭ key
  aflatTrill(14),   // #14 — A♭-Trill key

  // --- Trill keys (4) ---
  gTrill(15),     // #15 — G Trill key
  fsharpTrill(16), // #16 — F♯ Trill key
  eflatTrill(17),  // #17 — E♭ Trill key
  csharpTrill(20), // #20 — C♯ Trill key

  // --- Left hand little-finger keys (4) ---
  lowEflat(18), // #18 — Low E♭ key
  lowDflat(19), // #19 — Low D♭ key
  lowG(22),     // #22 — Low G key
  lowF(23),     // #23 — Low F key

  // --- Right hand little-finger keys (3) ---
  bflatTrill(21),   // #21 — B♭ Trill key
  littleFsharp(24), // #24 — Little Finger F♯ key
  littleAflat(25),  // #25 — Little Finger A♭ key
  ;

  const BassoonKey(this.bitIndex);

  /// Position in the 64-bit key mask backing [BassonFingeringVariation].
  /// This is also the key's number on the reference bassoon key diagram.
  /// Stable — do not reorder without rebuilding the mask.
  final int bitIndex;
}

/// State of an open tone hole.
///
/// Bassoonists use half-holing — covering a hole partially — to produce
/// certain notes. The five states are the standard ones shown in bassoon
/// fingering charts.
enum HoleState {
  /// ● — fully closed.
  closed(0),

  /// ◐ — approximately 1/4 open.
  quarterOpen(1),

  /// ◑ — approximately 1/2 open.
  halfOpen(2),

  /// ◕ — approximately 2/3 open.
  twoThirdsOpen(3),

  /// ○ — fully open.
  open(4);

  const HoleState(this.value);

  /// Numeric value 0-4, used when packing into the hole-state mask.
  final int value;

  String get label => switch (this) {
    HoleState.closed => 'closed',
    HoleState.quarterOpen => '1/4 open',
    HoleState.halfOpen => '1/2 open',
    HoleState.twoThirdsOpen => '2/3 open',
    HoleState.open => 'open',
  };
}

/// Open tone holes covered directly by fingers — not padded keys.
///
/// These are the six holes on the bassoon body that fingers press down on
/// directly. They are separate from [BassoonKey] because they are a different
/// physical mechanism: keys are levers that close remote holes, while these
/// are the holes themselves.
///
/// Each hole has a [HoleState] — it is not a simple open/closed boolean.
enum BassoonHole {
  a(1),
  b(2),
  c(3),
  d(4),
  e(5),
  f(6);

  const BassoonHole(this.bitIndex);

  /// Position in the 64-bit hole mask backing [BassonFingeringVariation].
  final int bitIndex;
}

/// The five trill keys. A "trill fingering" on bassoon is by definition a
/// *simpler* fingering, so it can be alternated rapidly; the full/basic
/// fingering is the more complex one that sounds better.
enum TrillKey {
  aflat(BassoonKey.aflatTrill),
  fsharp(BassoonKey.fsharpTrill),
  eflat(BassoonKey.eflatTrill),
  g(BassoonKey.gTrill),
  csharp(BassoonKey.csharpTrill),
  bflat(BassoonKey.bflatTrill);

  const TrillKey(this.key);

  final BassoonKey key;
}

/// Finger buttons A-G from the Figma component sets `2223:7724`…`2223:7734`.
///
/// A, B, D and E are the physical finger holes. C, F and G have no
/// corresponding key or hole — they are display-only placeholders in the
/// design, so [hole] is null for them.
enum FingerButton {
  a('A'),
  b('B'),
  c('C'),
  d('D'),
  e('E'),
  f('F'),
  g('G');

  const FingerButton(this.label);

  final String label;

  BassoonHole? get hole => switch (this) {
    FingerButton.a => BassoonHole.a,
    FingerButton.b => BassoonHole.b,
    FingerButton.d => BassoonHole.d,
    FingerButton.e => BassoonHole.e,
    FingerButton.c || FingerButton.f || FingerButton.g => null,
  };
}