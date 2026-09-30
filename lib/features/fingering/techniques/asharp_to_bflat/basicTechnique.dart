import '../../domain/basson_fingering_variation.dart';
import '../../domain/fingering_key.dart';

/// Basic A♭→B♭ fingering.
///
/// Six keys pressed (B♭, B, C, D, E, F) and all six holes fully closed.
final basicTechnique = BassonFingeringVariationBuilder()
    .lowBflat() // B♭
    .lowB() // B
    .lowC() // C
    .lowD() // D
    .lowE() // E
    .lowF() // F
    .holeA(HoleState.closed)
    .holeB(HoleState.closed)
    .holeC(HoleState.closed)
    .holeD(HoleState.closed)
    .holeE(HoleState.closed)
    .holeF(HoleState.closed)
    .build();
