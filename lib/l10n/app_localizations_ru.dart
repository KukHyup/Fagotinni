// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Fagotinni';

  @override
  String get appTagline => 'Спутник занятий для деревянных духовых';

  @override
  String get tabPractice => 'Занятия';

  @override
  String get tabMetronome => 'Метроном';

  @override
  String get tabTuner => 'Тюнер';

  @override
  String get tabMore => 'Ещё';

  @override
  String get language => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get concertPitch => 'A = 440 Гц';

  @override
  String get woodwindsHint => 'Фагот, кларнет, гобой и другие';

  @override
  String get practiceTitle => 'Ежедневные занятия';

  @override
  String get practiceStart => 'Начать занятие';

  @override
  String get practiceStop => 'Завершить занятие';

  @override
  String get practiceGoal => 'Цель на сегодня';

  @override
  String practiceMinutes(int count) {
    return '$count мин';
  }

  @override
  String get practiceDoneToday => 'Сегодня занимались';

  @override
  String get practiceNotDone => 'Сегодня ещё нет';

  @override
  String get practiceStreak => 'Дней подряд';

  @override
  String practiceStreakCount(int count) {
    return '$count';
  }

  @override
  String get practiceNotes => 'Над чем работали?';

  @override
  String get practiceNotesHint => 'Длинные звуки, гаммы, трость…';

  @override
  String get practiceElapsed => 'Время занятия';

  @override
  String get practiceSaved => 'Сохраняется только на этом устройстве';

  @override
  String get metronomeTitle => 'Метроном';

  @override
  String get metronomeBpm => 'Удары в минуту';

  @override
  String get metronomeStart => 'Старт';

  @override
  String get metronomeStop => 'Стоп';

  @override
  String get metronomeTimeSignature => 'Размер';

  @override
  String get tunerTitle => 'Тюнер';

  @override
  String get tunerListening => 'Слушаю…';

  @override
  String get tunerIdle => 'Возьмите ровный звук';

  @override
  String get tunerTooLow => 'Ниже';

  @override
  String get tunerInTune => 'Встроено';

  @override
  String get tunerTooHigh => 'Выше';

  @override
  String get tunerPermissionNeeded =>
      'Чтобы настроить инструмент, нужен доступ к микрофону.';

  @override
  String get tunerGrantPermission => 'Разрешить микрофон';

  @override
  String get tunerPermissionDenied =>
      'Доступ к микрофону запрещён. Его можно включить в настройках системы.';

  @override
  String get tunerInstrumentCaption => 'Камертон · деревянные духовые';

  @override
  String get moreTitle => 'Библиотека';

  @override
  String get moreSubtitle => 'Появится в следующих версиях';

  @override
  String get theoryTitle => 'Теория';

  @override
  String get theoryBody =>
      'Здесь будут ежедневные подсказки про интервалы, штрихи, дыхание и трость.';

  @override
  String get fingeringsTitle => 'Аппликатуры';

  @override
  String get fingeringsBody =>
      'Здесь появятся схемы для фагота, кларнета и гобоя — нота за нотой.';

  @override
  String get scoresTitle => 'Ноты';

  @override
  String get scoresBody => 'Здесь соберём этюды и пьесы для ежедневной работы.';

  @override
  String get newsTitle => 'Конкурсы';

  @override
  String get newsBody =>
      'Здесь будет лента конкурсов и фестивалей для деревянных духовых.';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get back => 'Назад';
}
