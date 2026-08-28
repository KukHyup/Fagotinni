import 'package:flutter/material.dart';
import 'package:fagotinni/app/locale_controller.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/placeholders/placeholder_screen.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          l10n.moreTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: FagotinniTheme.cream,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.moreSubtitle,
          style: const TextStyle(color: FagotinniTheme.muted),
        ),
        const SizedBox(height: 16),
        _LibraryTile(
          icon: Icons.menu_book_outlined,
          title: l10n.theoryTitle,
          onTap: () => _open(
            context,
            title: l10n.theoryTitle,
            body: l10n.theoryBody,
            icon: Icons.menu_book_outlined,
          ),
        ),
        _LibraryTile(
          icon: Icons.back_hand_outlined,
          title: l10n.fingeringsTitle,
          onTap: () => _open(
            context,
            title: l10n.fingeringsTitle,
            body: l10n.fingeringsBody,
            icon: Icons.back_hand_outlined,
          ),
        ),
        _LibraryTile(
          icon: Icons.queue_music,
          title: l10n.scoresTitle,
          onTap: () => _open(
            context,
            title: l10n.scoresTitle,
            body: l10n.scoresBody,
            icon: Icons.queue_music,
          ),
        ),
        _LibraryTile(
          icon: Icons.emoji_events_outlined,
          title: l10n.newsTitle,
          onTap: () => _open(
            context,
            title: l10n.newsTitle,
            body: l10n.newsBody,
            icon: Icons.emoji_events_outlined,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.language,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'ru', label: Text(l10n.languageRussian)),
            ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
          ],
          selected: {localeController.locale.languageCode},
          onSelectionChanged: (value) {
            localeController.setLocale(Locale(value.first));
          },
        ),
        const SizedBox(height: 16),
        Text(
          '${l10n.woodwindsHint} · ${l10n.concertPitch}',
          style: const TextStyle(color: FagotinniTheme.muted, fontSize: 13),
        ),
      ],
    );
  }

  void _open(
    BuildContext context, {
    required String title,
    required String body,
    required IconData icon,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlaceholderScreen(title: title, body: body, icon: icon),
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: FagotinniTheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: FagotinniTheme.bronze),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
