import 'package:flutter/material.dart';
import 'package:fagotinni/app/app.dart';
import 'package:fagotinni/app/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = LocaleController();
  await localeController.load();
  runApp(FagotinniApp(localeController: localeController));
}
