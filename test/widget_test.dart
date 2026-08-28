import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fagotinni/app/app.dart';
import 'package:fagotinni/app/locale_controller.dart';

Future<void> pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final locale = LocaleController();
  await tester.pumpWidget(FagotinniApp(localeController: locale));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('practice tab in Russian by default', (tester) async {
    await pumpApp(tester);
    expect(find.text('Fagotinni'), findsWidgets);
    expect(find.text('Ежедневные занятия'), findsOneWidget);
    expect(find.text('Начать занятие'), findsOneWidget);
  });

  testWidgets('starts and stops a practice session', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Начать занятие'));
    await tester.pump();
    expect(find.text('Завершить занятие'), findsOneWidget);
    await tester.tap(find.text('Завершить занятие'));
    await tester.pump();
    expect(find.text('Начать занятие'), findsOneWidget);
  });

  testWidgets('metronome can start and stop', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Метроном'));
    await tester.pumpAndSettle();
    expect(find.text('Удары в минуту'), findsOneWidget);
    await tester.tap(find.text('Старт'));
    await tester.pump();
    expect(find.text('Стоп'), findsOneWidget);
    await tester.tap(find.text('Стоп'));
    await tester.pump();
    expect(find.text('Старт'), findsOneWidget);
  });

  testWidgets('tuner tab shows concert pitch caption', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Тюнер'));
    await tester.pumpAndSettle();
    expect(find.text('Тюнер'), findsWidgets);
    expect(find.textContaining('деревянные духовые'), findsWidgets);
  });

  testWidgets('placeholder screens open from library', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ещё'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Теория'));
    await tester.pumpAndSettle();
    expect(find.text('Скоро'), findsOneWidget);
    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Конкурсы'));
    await tester.pumpAndSettle();
    expect(find.textContaining('конкурсов'), findsOneWidget);
  });

  testWidgets('language switch updates labels', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Ещё'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Library'), findsOneWidget);
    await tester.tap(find.text('Practice'));
    await tester.pumpAndSettle();
    expect(find.text('Daily practice'), findsOneWidget);
    expect(find.text('Start session'), findsOneWidget);
  });
}
