import 'package:fagotinni/features/fingering/domain/basson_fingering_variation.dart';
import 'package:fagotinni/features/fingering/domain/fingering_key.dart';
import 'package:fagotinni/features/fingering/domain/note.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BassoonKey', () {
    test('has 25 values matching the 25 keys on the diagram', () {
      expect(BassoonKey.values, hasLength(25));
    });

    test('bit indices are the diagram numbers 1-25', () {
      final indices = BassoonKey.values.map((k) => k.bitIndex).toSet();
      expect(indices, hasLength(25));
      expect(indices, {for (var i = 1; i <= 25; i++) i});
      expect(indices.every((i) => i >= 1 && i < 64), isTrue);
    });

    test('spot-check the mapping against the diagram', () {
      BassoonKey byDiagram(int n) =>
          BassoonKey.values.firstWhere((k) => k.bitIndex == n);

      expect(byDiagram(1).name, 'lowBflat');
      expect(byDiagram(5).name, 'whisperKey');
      expect(byDiagram(11).name, 'lowE');
      expect(byDiagram(14).name, 'aflatTrill');
      expect(byDiagram(15).name, 'gTrill');
      expect(byDiagram(21).name, 'bflatTrill');
      expect(byDiagram(23).name, 'lowF');
      expect(byDiagram(24).name, 'littleFsharp');
      expect(byDiagram(25).name, 'littleAflat');
    });

    test('the six trill keys are trill keys', () {
      expect(TrillKey.values, hasLength(6));
      for (final trill in TrillKey.values) {
        expect(trill.key.name, contains('rill'));
      }
    });
  });

  group('HoleState', () {
    test('has 5 states', () {
      expect(HoleState.values, hasLength(5));
      expect(HoleState.values.map((s) => s.value).toSet(), {0, 1, 2, 3, 4});
    });

    test('labels describe the opening', () {
      expect(HoleState.closed.label, 'closed');
      expect(HoleState.quarterOpen.label, '1/4 open');
      expect(HoleState.halfOpen.label, '1/2 open');
      expect(HoleState.twoThirdsOpen.label, '2/3 open');
      expect(HoleState.open.label, 'open');
    });
  });

  group('BassoonHole', () {
    test('has 6 values: A, B, C, D, E, F', () {
      expect(BassoonHole.values, hasLength(6));
      expect(BassoonHole.values.map((h) => h.name).toSet(), {
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
      });
    });

    test('bit indices are unique', () {
      final indices = BassoonHole.values.map((h) => h.bitIndex).toSet();
      expect(indices, hasLength(6));
    });

    test('finger buttons map to the physical holes', () {
      expect(FingerButton.a.hole, BassoonHole.a);
      expect(FingerButton.b.hole, BassoonHole.b);
      expect(FingerButton.d.hole, BassoonHole.d);
      expect(FingerButton.e.hole, BassoonHole.e);
      expect(FingerButton.c.hole, isNull);
      expect(FingerButton.f.hole, isNull);
      expect(FingerButton.g.hole, isNull);
    });
  });

  group('BassonFingeringVariation', () {
    test('empty has nothing pressed and all holes closed', () {
      expect(BassonFingeringVariation.empty.isEmpty, isTrue);
      expect(BassonFingeringVariation.empty.pressedKeyCount, 0);
      expect(BassonFingeringVariation.empty.openHoleCount, 0);
      for (final key in BassoonKey.values) {
        expect(BassonFingeringVariation.empty.isKeyPressed(key), isFalse);
      }
      for (final hole in BassoonHole.values) {
        expect(
          BassonFingeringVariation.empty.holeState(hole),
          HoleState.closed,
        );
      }
    });

    test('builder chains keys and holes independently', () {
      final v = BassonFingeringVariationBuilder()
          .lowBflat()
          .lowC()
          .holeD(HoleState.halfOpen)
          .build();

      expect(v.isKeyPressed(BassoonKey.lowBflat), isTrue);
      expect(v.isKeyPressed(BassoonKey.lowC), isTrue);
      expect(v.isKeyPressed(BassoonKey.lowB), isFalse);
      expect(v.holeState(BassoonHole.d), HoleState.halfOpen);
      expect(v.holeState(BassoonHole.a), HoleState.closed);
      expect(v.pressedKeyCount, 2);
      expect(v.openHoleCount, 1);
    });

    test('holeA() defaults to open', () {
      final v = BassonFingeringVariationBuilder().holeA().build();
      expect(v.holeState(BassoonHole.a), HoleState.open);
    });

    test('reordering the builder chain produces an equal variation', () {
      final a = BassonFingeringVariationBuilder()
          .lowBflat()
          .thumbBflat()
          .holeE(HoleState.quarterOpen)
          .build();
      final b = BassonFingeringVariationBuilder()
          .holeE(HoleState.quarterOpen)
          .lowBflat()
          .thumbBflat()
          .build();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different fingerings are not equal', () {
      final a = BassonFingeringVariationBuilder().lowBflat().build();
      final b = BassonFingeringVariationBuilder().lowB().build();
      expect(a, isNot(equals(b)));
    });

    test('a key variation never equals a hole variation', () {
      final key = BassonFingeringVariationBuilder().lowBflat().build();
      final hole = BassonFingeringVariationBuilder().holeA().build();
      expect(key, isNot(equals(hole)));
    });

    test('different hole states are not equal', () {
      final a = BassonFingeringVariationBuilder()
          .holeD(HoleState.closed)
          .build();
      final b = BassonFingeringVariationBuilder()
          .holeD(HoleState.halfOpen)
          .build();
      expect(a, isNot(equals(b)));
    });

    test('every single-key variation is distinct', () {
      final variations = [
        for (final key in BassoonKey.values)
          BassonFingeringVariation.empty.withKeys([key]),
      ];
      expect(variations.toSet(), hasLength(BassoonKey.values.length));
    });

    test('pressedKeys and releasedKeys partition all keys', () {
      final v = BassonFingeringVariationBuilder()
          .lowBflat()
          .thumbCsharp()
          .build();

      expect(v.pressedKeys, hasLength(2));
      expect(v.releasedKeys, hasLength(22));
      expect({...v.pressedKeys, ...v.releasedKeys}, hasLength(24));
    });

    test('openHoles reports holes that are not closed', () {
      final v = BassonFingeringVariationBuilder()
          .holeA(HoleState.open)
          .holeD(HoleState.halfOpen)
          .build();

      expect(v.openHoles, {BassoonHole.a, BassoonHole.d});
      expect(v.openHoleCount, 2);
    });

    test('trillKeys reports the held trill keys', () {
      final v = BassonFingeringVariationBuilder()
          .lowBflat()
          .fsharpTrill()
          .lowG()
          .build();

      expect(v.trillKeys, {TrillKey.fsharp});
    });

    test('withKey and withoutKey return modified copies', () {
      final original = BassonFingeringVariationBuilder().lowBflat().build();
      final extended = original.withKey(BassoonKey.highA);
      final trimmed = extended.withoutKey(BassoonKey.lowBflat);

      expect(original.isKeyPressed(BassoonKey.highA), isFalse);
      expect(extended.isKeyPressed(BassoonKey.lowBflat), isTrue);
      expect(extended.isKeyPressed(BassoonKey.highA), isTrue);
      expect(trimmed.isKeyPressed(BassoonKey.lowBflat), isFalse);
      expect(trimmed.isKeyPressed(BassoonKey.highA), isTrue);
    });

    test('withHoleState returns a modified copy and leaves the original intact', () {
      final original = BassonFingeringVariationBuilder().holeA().build();
      final half = original.withHoleState(BassoonHole.a, HoleState.halfOpen);
      final closed = half.withHoleState(BassoonHole.a, HoleState.closed);

      expect(original.holeState(BassoonHole.a), HoleState.open);
      expect(half.holeState(BassoonHole.a), HoleState.halfOpen);
      expect(closed.holeState(BassoonHole.a), HoleState.closed);
    });

    test('withKeys and withHoleStates set several at once', () {
      final v = BassonFingeringVariation.empty.withKeys([
        BassoonKey.lowB,
        BassoonKey.lowBflat,
      ]).withHoleStates({
        BassoonHole.a: HoleState.open,
        BassoonHole.b: HoleState.quarterOpen,
      });

      expect(v.pressedKeyCount, 2);
      expect(v.openHoleCount, 2);
      expect(v.isKeyPressed(BassoonKey.whisperKey), isFalse);
      expect(v.holeState(BassoonHole.a), HoleState.open);
      expect(v.holeState(BassoonHole.b), HoleState.quarterOpen);
    });

    test('builder can be cleared and reused', () {
      final builder = BassonFingeringVariationBuilder()
        ..lowBflat()
        ..highC()
        ..holeD(HoleState.halfOpen);
      expect(builder.pressedKeyCount, 2);
      expect(builder.openHoleCount, 1);

      builder.clear();
      expect(builder.pressedKeyCount, 0);
      expect(builder.openHoleCount, 0);
      expect(builder.build(), BassonFingeringVariation.empty);
    });

    test('builder can start from an existing variation', () {
      final base = BassonFingeringVariationBuilder().lowB().build();
      final next = BassonFingeringVariationBuilder.of(base).lowBflat().build();

      expect(next.pressedKeyCount, 2);
      expect(next.isKeyPressed(BassoonKey.lowB), isTrue);
      expect(next.isKeyPressed(BassoonKey.lowBflat), isTrue);
    });

    test('release unsets a key', () {
      final v = BassonFingeringVariationBuilder()
          .lowBflat()
          .whisperKey()
          .releaseWhisperKey()
          .build();

      expect(v.isKeyPressed(BassoonKey.whisperKey), isFalse);
      expect(v.isKeyPressed(BassoonKey.lowBflat), isTrue);
    });

    test('toString lists keys and holes separately', () {
      final v = BassonFingeringVariationBuilder()
          .lowBflat()
          .lowG()
          .holeD(HoleState.halfOpen)
          .build();

      expect(v.toString(), contains('keys:'));
      expect(v.toString(), contains('lowBflat'));
      expect(v.toString(), contains('holes:'));
      expect(v.toString(), contains('d=1/2 open'));
      expect(BassonFingeringVariation.empty.toString(), contains('empty'));
    });
  });

  group('note', () {
    test('midi numbers follow scientific pitch notation', () {
      expect(const ScoredNote(PitchClass.c, 4).midi, 60);
      expect(const ScoredNote(PitchClass.a, 4).midi, 69);
      expect(const ScoredNote(PitchClass.b, 1).midi, 35);
    });

    test('the lowest bassoon note is B♭1 = midi 34', () {
      expect(const ScoredNote(PitchClass.as, 1).midi, 34);
      expect(const ScoredNote(PitchClass.as, 1).label, 'B♭1');
    });

    test('note names are flat-based by default', () {
      expect(const ScoredNote(PitchClass.gs, 2).label, 'A♭2');
      expect(const ScoredNote(PitchClass.gs, 2).sharpName, 'G♯');
      expect(const ScoredNote(PitchClass.fs, 3).label, 'G♭3');
      expect(const ScoredNote(PitchClass.ds, 3).label, 'E♭3');
    });

    test('fromMidi round-trips across the bassoon range', () {
      for (var midi = 34; midi <= 76; midi++) {
        final pc = PitchClass.fromMidi(midi);
        expect(ScoredNote(pc, (midi ~/ 12) - 1).midi, midi);
      }
    });

    test('sorts by pitch', () {
      final notes = [
        const ScoredNote(PitchClass.as, 2),
        const ScoredNote(PitchClass.c, 2),
        const ScoredNote(PitchClass.b, 1),
      ]..sort();

      expect(notes.map((n) => n.label), ['B1', 'C2', 'B♭2']);
    });

    test('modes are named Basic and Trill', () {
      expect(FingeringMode.values, hasLength(2));
      expect(FingeringMode.basic.label, 'Basic');
      expect(FingeringMode.trill.label, 'Trill');
    });
  });
}