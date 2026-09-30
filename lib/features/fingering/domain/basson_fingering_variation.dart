import 'fingering_key.dart';

/// An immutable fingering: which keys are pressed and which holes are covered.
///
/// Two separate representations:
/// - [keyMask] — padded keys ([BassoonKey]), one bit per key
/// - [holeStates] — open tone holes ([BassoonHole]), each with a [HoleState]
///
/// Keys and holes are different physical mechanisms: keys are levers that
/// close remote holes, while holes are covered directly by fingers. Keeping
/// them separate makes the code readable and avoids mixing concepts.
///
/// Build one with [BassonFingeringVariationBuilder]:
/// ```dart
/// final v = BassonFingeringVariationBuilder()
///     .lowBflat()
///     .lowC()
///     .holeD(HoleState.halfOpen)
///     .build();
/// v.isKeyPressed(BassoonKey.lowBflat); // true
/// v.holeState(BassoonHole.d);           // HoleState.halfOpen
/// ```
class BassonFingeringVariation {
  const BassonFingeringVariation._(this.keyMask, this.holeStates);

  /// No keys pressed, all holes closed.
  static const empty = BassonFingeringVariation._(0, {
    BassoonHole.a: HoleState.closed,
    BassoonHole.b: HoleState.closed,
    BassoonHole.d: HoleState.closed,
    BassoonHole.e: HoleState.closed,
  });

  final int keyMask;

  /// State of each open tone hole. Unmodifiable.
  final Map<BassoonHole, HoleState> holeStates;

  // --- Keys ---

  /// Is [key] pressed?
  bool isKeyPressed(BassoonKey key) => (keyMask >> key.bitIndex) & 1 == 1;

  /// Keys that are pressed. Lazily built and cached.
  late final Set<BassoonKey> pressedKeys = () {
    final result = <BassoonKey>{};
    for (final key in BassoonKey.values) {
      if (isKeyPressed(key)) result.add(key);
    }
    return Set.unmodifiable(result);
  }();

  /// Keys that are *not* pressed.
  late final Set<BassoonKey> releasedKeys = () {
    final result = <BassoonKey>{};
    for (final key in BassoonKey.values) {
      if (!isKeyPressed(key)) result.add(key);
    }
    return Set.unmodifiable(result);
  }();

  int get pressedKeyCount => keyMask.bitCount;

  // --- Holes ---

  /// State of [hole].
  HoleState holeState(BassoonHole hole) => holeStates[hole]!;

  /// Holes that are not fully closed.
  late final Set<BassoonHole> openHoles = () {
    final result = <BassoonHole>{};
    for (final hole in BassoonHole.values) {
      if (holeStates[hole] != HoleState.closed) result.add(hole);
    }
    return Set.unmodifiable(result);
  }();

  int get openHoleCount => openHoles.length;

  // --- Combined ---

  bool get isEmpty => keyMask == 0 && openHoles.isEmpty;

  bool get isNotEmpty => keyMask != 0 || openHoles.isNotEmpty;

  /// Trill keys held down in this variation.
  Set<TrillKey> get trillKeys => {
    for (final trill in TrillKey.values)
      if (isKeyPressed(trill.key)) trill,
  };

  /// Returns a copy with [key] pressed.
  BassonFingeringVariation withKey(BassoonKey key) =>
      BassonFingeringVariation._(
        keyMask | (1 << key.bitIndex),
        holeStates,
      );

  /// Returns a copy with [key] released.
  BassonFingeringVariation withoutKey(BassoonKey key) =>
      BassonFingeringVariation._(
        keyMask & ~(1 << key.bitIndex),
        holeStates,
      );

  /// Returns a copy with [hole] set to [state].
  BassonFingeringVariation withHoleState(
    BassoonHole hole,
    HoleState state,
  ) => BassonFingeringVariation._(keyMask, {
    ...holeStates,
    hole: state,
  });

  /// Returns a copy with every key in [keys] pressed.
  BassonFingeringVariation withKeys(Iterable<BassoonKey> keys) {
    var mask = keyMask;
    for (final key in keys) {
      mask |= 1 << key.bitIndex;
    }
    return BassonFingeringVariation._(mask, holeStates);
  }

  /// Returns a copy with every hole in [holes] set to [state].
  BassonFingeringVariation withHoleStates(
    Map<BassoonHole, HoleState> holes,
  ) => BassonFingeringVariation._(keyMask, {...holeStates, ...holes});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BassonFingeringVariation &&
          other.keyMask == keyMask &&
          _mapsEqual(other.holeStates, holeStates);

  static bool _mapsEqual(
    Map<BassoonHole, HoleState> a,
    Map<BassoonHole, HoleState> b,
  ) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(keyMask, Object.hashAll(holeStates.entries));

  @override
  String toString() {
    if (isEmpty) return 'BassonFingeringVariation(<empty>)';
    final parts = <String>[];
    if (keyMask != 0) {
      parts.add('keys: ${pressedKeys.map((k) => k.name).join(' ')}');
    }
    final open = openHoles.toList();
    if (open.isNotEmpty) {
      parts.add(
        'holes: ${open.map((h) => '${h.name}=${holeStates[h]!.label}').join(' ')}',
      );
    }
    return 'BassonFingeringVariation(${parts.join(', ')})';
  }
}

/// Chainable builder for [BassonFingeringVariation].
///
/// Mutable on purpose: it is a throwaway scratch object, and only [build]
/// produces the immutable result. Cheap enough to create per note, but in
/// practice reuse one instance and call [clear].
class BassonFingeringVariationBuilder {
  BassonFingeringVariationBuilder([BassonFingeringVariation? base])
    : keyMask = base?.keyMask ?? 0,
      holeStates = Map.unmodifiable({
        for (final hole in BassoonHole.values)
          hole: base?.holeStates[hole] ?? HoleState.closed,
      });

  int keyMask;
  Map<BassoonHole, HoleState> holeStates;

  /// Starts a fresh fingering.
  factory BassonFingeringVariationBuilder.of(BassonFingeringVariation v) =>
      BassonFingeringVariationBuilder(v);

  bool isKeyPressed(BassoonKey key) => (keyMask >> key.bitIndex) & 1 == 1;

  HoleState holeState(BassoonHole hole) => holeStates[hole]!;

  int get pressedKeyCount => keyMask.bitCount;

  int get openHoleCount => holeStates.values
      .where((s) => s != HoleState.closed)
      .length;

  void clear() {
    keyMask = 0;
    holeStates = {
      for (final hole in BassoonHole.values) hole: HoleState.closed,
    };
  }

  BassonFingeringVariation build() => BassonFingeringVariation._(
    keyMask,
    Map.unmodifiable(holeStates),
  );

  BassonFingeringVariationBuilder _setKey(BassoonKey key) {
    keyMask |= 1 << key.bitIndex;
    return this;
  }

  BassonFingeringVariationBuilder _unsetKey(BassoonKey key) {
    keyMask &= ~(1 << key.bitIndex);
    return this;
  }

  // --- Left thumb ---
  BassonFingeringVariationBuilder lowBflat() => _setKey(BassoonKey.lowBflat);
  BassonFingeringVariationBuilder lowB() => _setKey(BassoonKey.lowB);
  BassonFingeringVariationBuilder lowC() => _setKey(BassoonKey.lowC);
  BassonFingeringVariationBuilder lowD() => _setKey(BassoonKey.lowD);
  BassonFingeringVariationBuilder whisperKey() =>
      _setKey(BassoonKey.whisperKey);
  BassonFingeringVariationBuilder thumbCsharp() =>
      _setKey(BassoonKey.thumbCsharp);
  BassonFingeringVariationBuilder highA() => _setKey(BassoonKey.highA);
  BassonFingeringVariationBuilder highC() => _setKey(BassoonKey.highC);
  BassonFingeringVariationBuilder highD() => _setKey(BassoonKey.highD);

  // --- Right thumb ---
  BassonFingeringVariationBuilder thumbBflat() =>
      _setKey(BassoonKey.thumbBflat);
  BassonFingeringVariationBuilder lowE() => _setKey(BassoonKey.lowE);
  BassonFingeringVariationBuilder thumbFsharp() =>
      _setKey(BassoonKey.thumbFsharp);
  BassonFingeringVariationBuilder thumbAflat() =>
      _setKey(BassoonKey.thumbAflat);
  BassonFingeringVariationBuilder aflatTrill() =>
      _setKey(BassoonKey.aflatTrill);

  // --- Trill keys ---
  BassonFingeringVariationBuilder gTrill() => _setKey(BassoonKey.gTrill);
  BassonFingeringVariationBuilder fsharpTrill() =>
      _setKey(BassoonKey.fsharpTrill);
  BassonFingeringVariationBuilder eflatTrill() =>
      _setKey(BassoonKey.eflatTrill);
  BassonFingeringVariationBuilder csharpTrill() =>
      _setKey(BassoonKey.csharpTrill);
  BassonFingeringVariationBuilder bflatTrill() =>
      _setKey(BassoonKey.bflatTrill);

  // --- Left hand little-finger keys ---
  BassonFingeringVariationBuilder lowEflat() => _setKey(BassoonKey.lowEflat);
  BassonFingeringVariationBuilder lowDflat() => _setKey(BassoonKey.lowDflat);
  BassonFingeringVariationBuilder lowG() => _setKey(BassoonKey.lowG);
  BassonFingeringVariationBuilder lowF() => _setKey(BassoonKey.lowF);

  // --- Right hand little-finger keys ---
  BassonFingeringVariationBuilder littleFsharp() =>
      _setKey(BassoonKey.littleFsharp);
  BassonFingeringVariationBuilder littleAflat() =>
      _setKey(BassoonKey.littleAflat);

  // --- Open tone holes ---
  BassonFingeringVariationBuilder holeA([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.a, state);
  BassonFingeringVariationBuilder holeB([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.b, state);
  BassonFingeringVariationBuilder holeC([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.c, state);
  BassonFingeringVariationBuilder holeD([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.d, state);
  BassonFingeringVariationBuilder holeE([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.e, state);
  BassonFingeringVariationBuilder holeF([HoleState state = HoleState.open]) =>
      _setHole(BassoonHole.f, state);

  BassonFingeringVariationBuilder _setHole(
    BassoonHole hole,
    HoleState state,
  ) {
    holeStates = {...holeStates, hole: state};
    return this;
  }

  // --- Release variants, for the rare case a note needs a key lifted ---
  BassonFingeringVariationBuilder releaseKey(BassoonKey key) =>
      _unsetKey(key);
  BassonFingeringVariationBuilder releaseWhisperKey() =>
      _unsetKey(BassoonKey.whisperKey);
  BassonFingeringVariationBuilder releaseHighA() =>
      _unsetKey(BassoonKey.highA);
}