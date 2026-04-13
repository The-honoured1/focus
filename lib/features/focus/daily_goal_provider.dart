import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyGoalNotifier extends StateNotifier<int> {
  DailyGoalNotifier() : super(240) {
    _loadGoal();
  }

  static const String _key = 'daily_focus_goal';

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 240;
  }

  Future<void> setGoal(int minutes) async {
    state = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, minutes);
  }
}

final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, int>((ref) {
  return DailyGoalNotifier();
});
