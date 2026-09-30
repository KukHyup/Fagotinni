# Technique Index

Every technique in this directory, one row each. The base fingering lives in
`<technique>/basicTechnique.dart`; the variations sit next to it.

| Technique | Type | Base fingering | Variations |
|---|---|---|---|
| [A♯→B♭](asharp_to_bflat/) | transition A♯→B♭ | B♭, B, C, D, E, F — all holes closed | [shake v1](asharp_to_bflat/shake_v1.dart), [v2](asharp_to_bflat/shake_v2.dart), [v3](asharp_to_bflat/shake_v3.dart), [v4](asharp_to_bflat/shake_v4.dart) |
| [B0](b0/) | single note | B, C, D, E, F — all holes closed | [trill v1](b0/trill_v1.dart), [shake v1](b0/shake_v1.dart), [v2](b0/shake_v2.dart), [v3](b0/shake_v3.dart) |
| [C1](c1/) | single note | C, D, E, F — all holes closed | [trill v1](c1/trill_v1.dart), [shake v1](c1/shake_v1.dart), [v2](c1/shake_v2.dart), [v3](c1/shake_v3.dart) |

## Shape of a technique

Two kinds exist, and they differ only in the base fingering — the variations
are built the same way from `basicTechnique`:

- **Transition** — a move between two notes, e.g. `asharp_to_bflat`.
- **Single note** — one note with alternatives for how to play it, e.g. `b0`,
  `c1`.

## Adding a technique

1. Create `<technique_name>/` with `basicTechnique.dart`
2. Add `<combo_name>_v<N>.dart` for each variation
3. Add a row to the table above

Do not add a new example section to [AGENTS.md](AGENTS.md) — it already shows
one technique of each shape.
