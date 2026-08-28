import 'package:flutter/material.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: FagotinniTheme.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: FagotinniTheme.bronze, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.comingSoon,
              style: const TextStyle(
                color: FagotinniTheme.bronze,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: const TextStyle(
                fontSize: 16,
                height: 1.45,
                color: FagotinniTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
