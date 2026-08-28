import 'package:flutter/material.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/practice/practice_store.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final PracticeStore _store = PracticeStore();
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController();
    _store.addListener(_onStore);
    _store.load().then((_) {
      if (mounted) _notes.text = _store.notes;
    });
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _store.removeListener(_onStore);
    _store.dispose();
    _notes.dispose();
    super.dispose();
  }

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = (_store.elapsedSeconds / (_store.goalMinutes * 60)).clamp(
      0.0,
      1.0,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.practiceTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: FagotinniTheme.cream,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: FagotinniTheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                l10n.practiceElapsed,
                style: const TextStyle(color: FagotinniTheme.muted),
              ),
              const SizedBox(height: 8),
              Text(
                _format(_store.elapsedSeconds),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: FagotinniTheme.cream,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: FagotinniTheme.surfaceHigh,
                  color: _store.doneToday
                      ? FagotinniTheme.inTune
                      : FagotinniTheme.bronze,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _store.doneToday
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _store.doneToday
                        ? FagotinniTheme.inTune
                        : FagotinniTheme.muted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _store.doneToday
                        ? l10n.practiceDoneToday
                        : l10n.practiceNotDone,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_store.running)
          FilledButton(
            onPressed: _store.stop,
            child: Text(l10n.practiceStop),
          )
        else
          FilledButton(
            onPressed: _store.start,
            child: Text(l10n.practiceStart),
          ),
        const SizedBox(height: 20),
        Text(
          l10n.practiceGoal,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [20, 30, 45]
              .map(
                (minutes) => ChoiceChip(
                  label: Text(l10n.practiceMinutes(minutes)),
                  selected: _store.goalMinutes == minutes,
                  selectedColor: FagotinniTheme.bronze.withValues(alpha: 0.35),
                  labelStyle: TextStyle(
                    color: _store.goalMinutes == minutes
                        ? FagotinniTheme.cream
                        : FagotinniTheme.muted,
                    fontWeight: FontWeight.w700,
                  ),
                  onSelected: (_) => _store.setGoal(minutes),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: FagotinniTheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department, color: FagotinniTheme.bronze),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.practiceStreak,
                    style: const TextStyle(color: FagotinniTheme.muted),
                  ),
                  Text(
                    l10n.practiceStreakCount(_store.streak),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.practiceNotes,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notes,
          maxLines: 3,
          onChanged: _store.setNotes,
          decoration: InputDecoration(hintText: l10n.practiceNotesHint),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.practiceSaved,
          style: const TextStyle(color: FagotinniTheme.muted, fontSize: 13),
        ),
      ],
    );
  }
}
