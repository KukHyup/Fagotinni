// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fagotinni';

  @override
  String get appTagline => 'Practice companion for woodwinds';

  @override
  String get tabPractice => 'Practice';

  @override
  String get tabMetronome => 'Metronome';

  @override
  String get tabTuner => 'Tuner';

  @override
  String get tabMore => 'More';

  @override
  String get language => 'Language';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get concertPitch => 'A = 440 Hz';

  @override
  String get woodwindsHint => 'Bassoon, clarinet, oboe and friends';

  @override
  String get practiceTitle => 'Daily practice';

  @override
  String get practiceStart => 'Start session';

  @override
  String get practiceStop => 'Finish session';

  @override
  String get practiceGoal => 'Today\'s goal';

  @override
  String practiceMinutes(int count) {
    return '$count min';
  }

  @override
  String get practiceDoneToday => 'Practiced today';

  @override
  String get practiceNotDone => 'Not yet today';

  @override
  String get practiceStreak => 'Day streak';

  @override
  String practiceStreakCount(int count) {
    return '$count';
  }

  @override
  String get practiceNotes => 'What did you work on?';

  @override
  String get practiceNotesHint => 'Long tones, scales, reeds…';

  @override
  String get practiceElapsed => 'Session time';

  @override
  String get practiceSaved => 'Saved on this device only';

  @override
  String get metronomeTitle => 'Metronome';

  @override
  String get metronomeBpm => 'BPM';

  @override
  String get metronomeStart => 'Start';

  @override
  String get metronomeStop => 'Stop';

  @override
  String get metronomeTimeSignature => 'Time signature';

  @override
  String get tunerTitle => 'Tuner';

  @override
  String get tunerListening => 'Listening…';

  @override
  String get tunerIdle => 'Play a steady tone';

  @override
  String get tunerTooLow => 'Too low';

  @override
  String get tunerInTune => 'In tune';

  @override
  String get tunerTooHigh => 'Too high';

  @override
  String get tunerPermissionNeeded =>
      'Microphone access is needed to tune your instrument.';

  @override
  String get tunerGrantPermission => 'Allow microphone';

  @override
  String get tunerPermissionDenied =>
      'Microphone permission was denied. You can enable it in system settings.';

  @override
  String get tunerInstrumentCaption => 'Concert pitch · woodwinds';

  @override
  String get moreTitle => 'Library';

  @override
  String get moreSubtitle => 'Coming in the next versions';

  @override
  String get theoryTitle => 'Theory';

  @override
  String get theoryBody =>
      'Daily tips on intervals, articulation, breathing and reeds will live here.';

  @override
  String get fingeringsTitle => 'Fingerings';

  @override
  String get fingeringsBody =>
      'Charts for bassoon, clarinet and oboe will appear here, note by note.';

  @override
  String get scoresTitle => 'Sheet music';

  @override
  String get scoresBody =>
      'Etudes and pieces for daily work will be collected here.';

  @override
  String get newsTitle => 'Competitions';

  @override
  String get newsBody =>
      'Upcoming contests and festivals for woodwind players will show up here.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get back => 'Back';
}
