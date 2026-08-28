import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeStore extends ChangeNotifier {
  PracticeStore();

  static const _goalKey = 'practice_goal_minutes';
  static const _notesKey = 'practice_notes';
  static const _lastDateKey = 'practice_last_date';
  static const _streakKey = 'practice_streak';
  static const _todaySecondsKey = 'practice_today_seconds';
  static const _todayDateKey = 'practice_today_date';

  int goalMinutes = 30;
  String notes = '';
  int streak = 0;
  int todaySeconds = 0;
  bool running = false;

  DateTime? _sessionStartedAt;
  Timer? _ticker;
  String _todayStamp = _stamp(DateTime.now());

  int get elapsedSeconds {
    final live = _sessionStartedAt == null
        ? 0
        : DateTime.now().difference(_sessionStartedAt!).inSeconds;
    return todaySeconds + live;
  }

  bool get doneToday => elapsedSeconds >= goalMinutes * 60;

  static String _stamp(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    goalMinutes = prefs.getInt(_goalKey) ?? 30;
    notes = prefs.getString(_notesKey) ?? '';
    streak = prefs.getInt(_streakKey) ?? 0;
    _todayStamp = _stamp(DateTime.now());
    final storedDay = prefs.getString(_todayDateKey);
    if (storedDay == _todayStamp) {
      todaySeconds = prefs.getInt(_todaySecondsKey) ?? 0;
    } else {
      todaySeconds = 0;
    }
    notifyListeners();
  }

  Future<void> setGoal(int minutes) async {
    goalMinutes = minutes;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalKey, minutes);
  }

  Future<void> setNotes(String value) async {
    notes = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, value);
    notifyListeners();
  }

  void start() {
    if (running) return;
    running = true;
    _sessionStartedAt = DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stop() async {
    if (!running) return;
    final extra = DateTime.now().difference(_sessionStartedAt!).inSeconds;
    todaySeconds += extra;
    running = false;
    _sessionStartedAt = null;
    _ticker?.cancel();
    await _persistToday();
    await _maybeMarkComplete();
    notifyListeners();
  }

  Future<void> _persistToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_todaySecondsKey, todaySeconds);
    await prefs.setString(_todayDateKey, _todayStamp);
  }

  Future<void> _maybeMarkComplete() async {
    if (!doneToday) return;
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_lastDateKey);
    if (last == _todayStamp) return;

    final yesterday = _stamp(DateTime.now().subtract(const Duration(days: 1)));
    streak = last == yesterday ? streak + 1 : 1;
    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastDateKey, _todayStamp);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
