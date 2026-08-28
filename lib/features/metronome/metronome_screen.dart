import 'package:flutter/material.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/metronome/metronome_controller.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  final MetronomeController _metro = MetronomeController();

  @override
  void initState() {
    super.initState();
    _metro.addListener(_onChange);
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _metro.removeListener(_onChange);
    _metro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visualBeat = _metro.running ? _metro.beat : -1;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              Text(
                l10n.metronomeTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: FagotinniTheme.cream,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_metro.beatsPerBar, (index) {
                  final active = visualBeat == index;
                  final accent = index == 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 90),
                      width: accent ? 28 : 22,
                      height: accent ? 28 : 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active
                            ? (accent
                                ? FagotinniTheme.bronze
                                : FagotinniTheme.cream)
                            : FagotinniTheme.surfaceHigh,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  '${_metro.bpm}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: FagotinniTheme.cream,
                  ),
                ),
              ),
              Center(
                child: Text(
                  l10n.metronomeBpm,
                  style: const TextStyle(
                    color: FagotinniTheme.muted,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => _metro.setBpm(_metro.bpm - 1),
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Slider(
                      min: 40,
                      max: 240,
                      value: _metro.bpm.toDouble(),
                      onChanged: (value) => _metro.setBpm(value.round()),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => _metro.setBpm(_metro.bpm + 1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.metronomeTimeSignature,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [2, 3, 4]
                    .map(
                      (beats) => ChoiceChip(
                        label: Text('$beats/4'),
                        selected: _metro.beatsPerBar == beats,
                        selectedColor: FagotinniTheme.bronze.withValues(
                          alpha: 0.35,
                        ),
                        onSelected: (_) => _metro.setBeatsPerBar(beats),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: _metro.running
              ? FilledButton(
                  onPressed: _metro.stop,
                  child: Text(l10n.metronomeStop),
                )
              : FilledButton(
                  onPressed: _metro.start,
                  child: Text(l10n.metronomeStart),
                ),
        ),
      ],
    );
  }
}
