# Bassoon Techniques

This directory contains all bassoon fingering techniques. Each technique is a
transition between two notes (e.g., A♭→B♭) with a basic fingering and one or
more combo variations.

## Critical NFR

**Structure is immutable.** `BassonFingeringVariation` is a value object —
once built, it cannot be modified. All mutations return a new copy:

- `withKey(key)` — returns a copy with the key pressed
- `withoutKey(key)` — returns a copy with the key released
- `withHoleState(hole, state)` — returns a copy with the hole state changed
- `withKeys(keys)` / `withHoleStates(holes)` — batch versions

The builder (`BassonFingeringVariationBuilder`) is the only mutable type and
is a throwaway scratch object. Only `build()` produces the immutable result.

## Structure

```
techniques/
  <technique_name>/
    basicTechnique.dart     — the basic fingering (BassonFingeringVariation)
    advancedTechnique.dart  — optional advanced fingering
    <combo_name>_v<N>.dart  — a combo variation with N steps
```

### Example: `asharp_to_bflat/`

```
asharp_to_bflat/
  basicTechnique.dart   — basic A♭→B♭ fingering
  shake_v1.dart         — Shake combo, variation 1 (2 steps)
  shake_v2.dart         — Shake combo, variation 2 (2 steps)
  shake_v3.dart         — Shake combo, variation 3 (2 steps)
  shake_v4.dart         — Shake combo, variation 4 (2 steps)
```

## Combo Starting Point

**Every combo starts from either the basic technique or the advanced technique.**
Step 1 of every variation is always one of these two — never a standalone
fingering. Step 2+ are derived by applying `withKey` / `withoutKey` /
`withHoleState` to that starting point.

```dart
// Step 1 = basic technique, step 2 = basic + one key
static final List<BassonFingeringVariation> steps = [
  basicTechnique,
  basicTechnique.withKey(BassoonKey.lowDflat),
];
```

If a technique has an `advancedTechnique.dart`, combos may start from that
instead — the choice depends on the player's level.

## File Naming

- `basicTechnique.dart` — always this exact name
- `<combo_name>_v<N>.dart` — combo name from `Combo.filePrefix`, then `_v<N>`
  - Example: `shake_v1.dart`, `trill_v2.dart`, `wkeyon_v1.dart`

## `basicTechnique.dart`

Contains a top-level `const` of type `BassonFingeringVariation`, built from
the builder:

```dart
import '../domain/basson_fingering_variation.dart';
import '../domain/fingering_key.dart';

const basicTechnique = BassonFingeringVariationBuilder()
    .lowBflat()
    .lowB()
    // ... more keys and holes ...
    .build();
```

## `<combo_name>_v<N>.dart`

Contains a class with:
- `static const comboType` — the `Combo` enum value (e.g., `Combo.shake`)
- `static final List<BassonFingeringVariation> steps` — the steps of this combo

Step 1 is always `basicTechnique` (or `advancedTechnique`). Later steps are
derived by applying `withKey` / `withoutKey` / `withHoleState`.

```dart
import '../domain/basson_fingering_variation.dart';
import '../domain/combo.dart';
import '../domain/fingering_key.dart';
import 'basicTechnique.dart';

class ShakeV1 {
  static const comboType = Combo.shake;

  static final List<BassonFingeringVariation> steps = [
    basicTechnique,
    basicTechnique.withKey(BassoonKey.lowDflat),
  ];
}
```

## Adding a New Technique

1. Create a directory: `techniques/<technique_name>/`
2. Add `basicTechnique.dart` with the basic fingering
3. For each combo variation, add `<combo_name>_v<N>.dart`
4. The class name is `<ComboName><V><N>` (e.g., `ShakeV1`, `TrillV2`)

## Adding a New Combo

1. Add the value to the `Combo` enum in `lib/features/fingering/domain/combo.dart`
2. Add the `displayName` and `filePrefix` to the `ComboInfo` extension
3. Create variation files using the `filePrefix` (e.g., `shake_v1.dart`)

## Combo Types

| Enum Value | Display Name | File Prefix | Description |
|---|---|---|---|
| `Combo.shake` | Shake | `shake` | Rapid alternation between two notes |
| `Combo.trill` | Trill | `trill` | Rapid alternation a second apart |
| `Combo.wKeyOn` | Whisper Key On | `wkeyon` | Whisper key held down |
| `Combo.wKeyOff` | Whisper Key Off | `wkeyoff` | Whisper key not held |
| `Combo.veryFast` | Very Fast | `veryfast` | Simplified fingering for rapid passages |
| `Combo.noDflatKey` | No D♭ Key | `nodflatkey` | Avoids the D♭ key |

## Key Concepts

- **Technique** — a transition between two notes (e.g., A♭→B♭). Lives in
  `techniques/<technique_name>/`.
- **Combo** — a playing technique (e.g., Shake, Trill). Defined in the `Combo`
  enum. Each combo has one or more variations.
- **Variation** — a version of a combo (e.g., Shake v1, Shake v2). Each
  variation has one or more steps.
- **Step** — a single fingering snapshot (`BassonFingeringVariation`). The UI
  slider switches between steps.
- **BassonFingeringVariation** — an immutable snapshot of which keys are
  pressed and which holes are covered. Built with
  `BassonFingeringVariationBuilder`.
- **BassoonKey** — a physical key on the bassoon. The `bitIndex` is the key's
  number on the reference bassoon key diagram (1-25).
- **BassoonHole** — an open tone hole (A, B, C, D, E, F). Each hole has a
  `HoleState` (closed, 1/4 open, 1/2 open, 2/3 open, open).