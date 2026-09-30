import '../../domain/basson_fingering_variation.dart';
import '../../domain/combo.dart';
import '../../domain/fingering_key.dart';
import 'basicTechnique.dart';

/// Shake variation 4 of the A♭→B♭ combo.
///
/// Step 1 is the basic technique. Step 2 releases the Low F key and adds the
/// Little Finger A♭ key.
class ShakeV4 {
  static const comboType = Combo.shake;

  static final List<BassonFingeringVariation> steps = [
    basicTechnique,
    basicTechnique
        .withoutKey(BassoonKey.lowF)
        .withKey(BassoonKey.littleAflat),
  ];
}
