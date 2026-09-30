import '../../domain/basson_fingering_variation.dart';
import '../../domain/combo.dart';
import '../../domain/fingering_key.dart';
import 'basicTechnique.dart';

/// Shake variation 2 of the C1 combo.
///
/// Step 1 is the basic technique. Step 2 releases the Low F key.
class ShakeV2 {
  static const comboType = Combo.shake;

  static final List<BassonFingeringVariation> steps = [
    basicTechnique,
    basicTechnique.withoutKey(BassoonKey.lowF),
  ];
}
