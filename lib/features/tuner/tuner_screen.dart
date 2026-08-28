import 'package:flutter/material.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/tuner/tuner_controller.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final TunerController _tuner = TunerController();

  @override
  void initState() {
    super.initState();
    _tuner.addListener(_onChange);
    _tuner.init().then((_) {
      if (_tuner.permission == TunerPermission.granted) {
        _tuner.start();
      }
    });
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tuner.removeListener(_onChange);
    _tuner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final estimate = _tuner.estimate;
    final cents = estimate?.cents ?? 0;
    final inTune = estimate != null && cents.abs() <= 8;
    Color needleColor = FagotinniTheme.muted;
    String status = l10n.tunerIdle;
    if (estimate != null) {
      if (inTune) {
        needleColor = FagotinniTheme.inTune;
        status = l10n.tunerInTune;
      } else if (cents < 0) {
        needleColor = FagotinniTheme.flat;
        status = l10n.tunerTooLow;
      } else {
        needleColor = FagotinniTheme.sharp;
        status = l10n.tunerTooHigh;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.tunerTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: FagotinniTheme.cream,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.tunerInstrumentCaption,
          style: const TextStyle(color: FagotinniTheme.muted),
        ),
        const SizedBox(height: 24),
        if (_tuner.permission != TunerPermission.granted) ...[
          Text(l10n.tunerPermissionNeeded),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await _tuner.requestPermission();
              if (_tuner.permission == TunerPermission.granted) {
                await _tuner.start();
              }
            },
            child: Text(l10n.tunerGrantPermission),
          ),
          if (_tuner.permission == TunerPermission.permanentlyDenied) ...[
            const SizedBox(height: 12),
            Text(
              l10n.tunerPermissionDenied,
              style: const TextStyle(color: FagotinniTheme.muted),
            ),
          ],
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: FagotinniTheme.surface,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                Text(
                  estimate == null
                      ? '—'
                      : '${estimate.noteName}${estimate.octave}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: FagotinniTheme.cream,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: needleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  estimate == null
                      ? l10n.concertPitch
                      : '${estimate.frequencyHz.toStringAsFixed(1)} Hz',
                  style: const TextStyle(color: FagotinniTheme.muted),
                ),
                const SizedBox(height: 28),
                _TunerNeedle(cents: cents.clamp(-50, 50)),
                const SizedBox(height: 12),
                Text(
                  estimate == null
                      ? l10n.tunerIdle
                      : '${cents >= 0 ? '+' : ''}${cents.toStringAsFixed(0)} ¢',
                  style: const TextStyle(color: FagotinniTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _tuner.listening ? l10n.tunerListening : l10n.tunerIdle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: FagotinniTheme.muted),
          ),
        ],
      ],
    );
  }
}

class _TunerNeedle extends StatelessWidget {
  const _TunerNeedle({required this.cents});

  final double cents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final x = (cents + 50) / 100 * width;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: const LinearGradient(
                    colors: [
                      FagotinniTheme.flat,
                      FagotinniTheme.inTune,
                      FagotinniTheme.sharp,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: width / 2 - 1,
                top: 0,
                bottom: 0,
                child: Container(width: 2, color: FagotinniTheme.cream),
              ),
              Positioned(
                left: x - 8,
                child: Container(
                  width: 16,
                  height: 32,
                  decoration: BoxDecoration(
                    color: FagotinniTheme.cream,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
