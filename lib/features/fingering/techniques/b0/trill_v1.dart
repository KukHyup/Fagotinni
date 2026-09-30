import '../../domain/basson_fingering_variation.dart';
import '../../domain/combo.dart';
import '../../domain/fingering_key.dart';
import 'basicTechnique.dart';

/// Trill variation 1 of the B0 combo.
///
/// Step 1 is the basic technique. Step 2 adds the Low D♭ key.
class TrillV1 {
  static const comboType = Combo.trill;

  static final List<BassonFingeringVariation> steps = [
    basicTechnique,
    basicTechnique.withKey(BassoonKey.lowDflat),
  ];
}
