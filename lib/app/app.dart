import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fagotinni/app/locale_controller.dart';
import 'package:fagotinni/app/theme.dart';
import 'package:fagotinni/features/shell/home_shell.dart';
import 'package:fagotinni/l10n/app_localizations.dart';

class FagotinniApp extends StatelessWidget {
  const FagotinniApp({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Fagotinni',
          debugShowCheckedModeBanner: false,
          theme: FagotinniTheme.dark(),
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomeShell(localeController: localeController),
        );
      },
    );
  }
}
