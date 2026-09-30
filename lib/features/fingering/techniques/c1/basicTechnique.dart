import '../../domain/basson_fingering_variation.dart';
import '../../domain/fingering_key.dart';

/// Basic C1 fingering.
///
/// Four keys pressed (C, D, E, F) and all six holes fully closed.
final basicTechnique = BassonFingeringVariationBuilder()
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
