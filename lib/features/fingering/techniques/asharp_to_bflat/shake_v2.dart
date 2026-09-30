import '../../domain/basson_fingering_variation.dart';
import '../../domain/combo.dart';
import '../../domain/fingering_key.dart';
import 'basicTechnique.dart';

/// Shake variation 2 of the A♭→B♭ combo.
///
/// Step 1 is the basic technique. Step 2 adds the Low D♭ and Low E♭ keys.
class ShakeV2 {
  static const comboType = Combo.shake;

  static final List<BassonFingeringVariation> steps = [
    basicTechnique,
    basicTechnique
        .withKey(BassoonKey.lowDflat)
        .withKey(BassoonKey.lowEflat),
  ];
}
