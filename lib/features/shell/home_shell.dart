import 'package:flutter/material.dart';
import 'package:fagotinni/app/locale_controller.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/metronome/metronome_screen.dart';
import 'package:fagotinni/features/more/more_screen.dart';
import 'package:fagotinni/features/practice/practice_screen.dart';
import 'package:fagotinni/features/tuner/tuner_screen.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      const PracticeScreen(),
      const MetronomeScreen(),
      const TunerScreen(),
      MoreScreen(localeController: widget.localeController),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: FagotinniTheme.cream,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.appTagline,
                    style: const TextStyle(
                      fontSize: 14,
                      color: FagotinniTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(index: _index, children: pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.music_note_outlined),
            selectedIcon: const Icon(Icons.music_note),
            label: l10n.tabPractice,
          ),
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: l10n.tabMetronome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.graphic_eq_outlined),
            selectedIcon: const Icon(Icons.graphic_eq),
            label: l10n.tabTuner,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined),
            selectedIcon: const Icon(Icons.library_music),
            label: l10n.tabMore,
          ),
        ],
      ),
    );
  }
}
