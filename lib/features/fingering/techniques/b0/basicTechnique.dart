import '../../domain/basson_fingering_variation.dart';
import '../../domain/fingering_key.dart';

/// Basic B0 fingering — the lowest B on the bassoon.
///
/// Five keys pressed (B, C, D, E, F) and all six holes fully closed.
final basicTechnique = BassonFingeringVariationBuilder()
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
