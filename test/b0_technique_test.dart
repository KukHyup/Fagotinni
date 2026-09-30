import 'package:fagotinni/features/fingering/domain/combo.dart';
import 'package:fagotinni/features/fingering/domain/fingering_key.dart';
import 'package:fagotinni/features/fingering/techniques/b0/basicTechnique.dart';
import 'package:fagotinni/features/fingering/techniques/b0/shake_v1.dart';
import 'package:fagotinni/features/fingering/techniques/b0/shake_v2.dart';
import 'package:fagotinni/features/fingering/techniques/b0/shake_v3.dart';
import 'package:fagotinni/features/fingering/techniques/b0/trill_v1.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const baseKeys = {
    BassoonKey.lowB,
    BassoonKey.lowC,
    BassoonKey.lowD,
    BassoonKey.lowE,
    BassoonKey.lowF,
  };

  group('b0 basic technique', () {
    test('presses B, C, D, E and F and nothing else', () {
      expect(basicTechnique.pressedKeys, baseKeys);
    });

    test('closes all six holes', () {
      expect(basicTechnique.openHoleCount, 0);
      for (final hole in BassoonHole.values) {
        expect(basicTechnique.holeState(hole), HoleState.closed);
      }
    });
  });

  group('b0 combos', () {
    test('every variation has two steps, starting from the basic technique',
        () {
      for (final steps in [
        TrillV1.steps,
        ShakeV1.steps,
        ShakeV2.steps,
        ShakeV3.steps,
      ]) {
        expect(steps, hasLength(2));
        expect(steps.first, basicTechnique);
      }
    });

    test('no variation opens a hole', () {
      for (final steps in [
        TrillV1.steps,
        ShakeV1.steps,
        ShakeV2.steps,
        ShakeV3.steps,
      ]) {
        for (final step in steps) {
          expect(step.openHoleCount, 0, reason: '$step');
        }
      }
    });

    test('trill v1 adds the Low D♭ key', () {
      expect(TrillV1.comboType, Combo.trill);
      expect(
        TrillV1.steps.last.pressedKeys,
        {...baseKeys, BassoonKey.lowDflat},
      );
    });

    test('shake v1 adds the Low D♭ and Low E♭ keys', () {
      expect(ShakeV1.comboType, Combo.shake);
      expect(
        ShakeV1.steps.last.pressedKeys,
        {...baseKeys, BassoonKey.lowDflat, BassoonKey.lowEflat},
      );
    });

    test('shake v2 releases the Low F key', () {
      expect(ShakeV2.comboType, Combo.shake);
      expect(
        ShakeV2.steps.last.pressedKeys,
        {...baseKeys}..remove(BassoonKey.lowF),
      );
    });

    test('shake v3 releases the Low F key and adds Little Finger A♭', () {
      expect(ShakeV3.comboType, Combo.shake);
      expect(
        ShakeV3.steps.last.pressedKeys,
        {
          ...baseKeys..remove(BassoonKey.lowF),
          BassoonKey.littleAflat,
        },
      );
    });
  });
}
