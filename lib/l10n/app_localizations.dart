import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fagotinni'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Practice companion for woodwinds'**
  String get appTagline;

  /// No description provided for @tabPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get tabPractice;

  /// No description provided for @tabMetronome.
  ///
  /// In en, this message translates to:
  /// **'Metronome'**
  String get tabMetronome;

  /// No description provided for @tabTuner.
  ///
  /// In en, this message translates to:
  /// **'Tuner'**
  String get tabTuner;

  /// No description provided for @tabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @concertPitch.
  ///
  /// In en, this message translates to:
  /// **'A = 440 Hz'**
  String get concertPitch;

  /// No description provided for @woodwindsHint.
  ///
  /// In en, this message translates to:
  /// **'Bassoon, clarinet, oboe and friends'**
  String get woodwindsHint;

  /// No description provided for @practiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily practice'**
  String get practiceTitle;

  /// No description provided for @practiceStart.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get practiceStart;

  /// No description provided for @practiceStop.
  ///
  /// In en, this message translates to:
  /// **'Finish session'**
  String get practiceStop;

  /// No description provided for @practiceGoal.
  ///
  /// In en, this message translates to:
  /// **'Today\'s goal'**
  String get practiceGoal;

  /// No description provided for @practiceMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String practiceMinutes(int count);

  /// No description provided for @practiceDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Practiced today'**
  String get practiceDoneToday;

  /// No description provided for @practiceNotDone.
  ///
  /// In en, this message translates to:
  /// **'Not yet today'**
  String get practiceNotDone;

  /// No description provided for @practiceStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get practiceStreak;

  /// No description provided for @practiceStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String practiceStreakCount(int count);

  /// No description provided for @practiceNotes.
  ///
  /// In en, this message translates to:
  /// **'What did you work on?'**
  String get practiceNotes;

  /// No description provided for @practiceNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Long tones, scales, reeds…'**
  String get practiceNotesHint;

  /// No description provided for @practiceElapsed.
  ///
  /// In en, this message translates to:
  /// **'Session time'**
  String get practiceElapsed;

  /// No description provided for @practiceSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only'**
  String get practiceSaved;

  /// No description provided for @metronomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Metronome'**
  String get metronomeTitle;

  /// No description provided for @metronomeBpm.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get metronomeBpm;

  /// No description provided for @metronomeStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get metronomeStart;

  /// No description provided for @metronomeStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get metronomeStop;

  /// No description provided for @metronomeTimeSignature.
  ///
  /// In en, this message translates to:
  /// **'Time signature'**
  String get metronomeTimeSignature;

  /// No description provided for @tunerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tuner'**
  String get tunerTitle;

  /// No description provided for @tunerListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get tunerListening;

  /// No description provided for @tunerIdle.
  ///
  /// In en, this message translates to:
  /// **'Play a steady tone'**
  String get tunerIdle;

  /// No description provided for @tunerTooLow.
  ///
  /// In en, this message translates to:
  /// **'Too low'**
  String get tunerTooLow;

  /// No description provided for @tunerInTune.
  ///
  /// In en, this message translates to:
  /// **'In tune'**
  String get tunerInTune;

  /// No description provided for @tunerTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Too high'**
  String get tunerTooHigh;

  /// No description provided for @tunerPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is needed to tune your instrument.'**
  String get tunerPermissionNeeded;

  /// No description provided for @tunerGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone'**
  String get tunerGrantPermission;

  /// No description provided for @tunerPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission was denied. You can enable it in system settings.'**
  String get tunerPermissionDenied;

  /// No description provided for @tunerInstrumentCaption.
  ///
  /// In en, this message translates to:
  /// **'Concert pitch · woodwinds'**
  String get tunerInstrumentCaption;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get moreTitle;

  /// No description provided for @moreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming in the next versions'**
  String get moreSubtitle;

  /// No description provided for @theoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Theory'**
  String get theoryTitle;

  /// No description provided for @theoryBody.
  ///
  /// In en, this message translates to:
  /// **'Daily tips on intervals, articulation, breathing and reeds will live here.'**
  String get theoryBody;

  /// No description provided for @fingeringsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fingerings'**
  String get fingeringsTitle;

  /// No description provided for @fingeringsBody.
  ///
  /// In en, this message translates to:
  /// **'Charts for bassoon, clarinet and oboe will appear here, note by note.'**
  String get fingeringsBody;

  /// No description provided for @scoresTitle.
  ///
  /// In en, this message translates to:
  /// **'Sheet music'**
  String get scoresTitle;

  /// No description provided for @scoresBody.
  ///
  /// In en, this message translates to:
  /// **'Etudes and pieces for daily work will be collected here.'**
  String get scoresBody;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'Competitions'**
  String get newsTitle;

  /// No description provided for @newsBody.
  ///
  /// In en, this message translates to:
  /// **'Upcoming contests and festivals for woodwind players will show up here.'**
  String get newsBody;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
