import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/streak.dart';
import '../../services/hive_service.dart';

class StreakNotifier extends StateNotifier<StreakModel> {
  StreakNotifier() : super(HiveService.getStreak() ?? StreakModel(currentStreak: 0, lastActiveDate: DateTime.now().subtract(const Duration(days: 1))));

  void updateStreak() {
    final now = DateTime.now();
    final lastActive = state.lastActiveDate;
    final lastActiveDay = DateTime(lastActive.year, lastActive.month, lastActive.day);
    final today = DateTime(now.year, now.month, now.day);

    if (today.isAtSameMomentAs(lastActiveDay)) {
      // Already active today
      return;
    }

    int newStreak = state.currentStreak;
    if (today.difference(lastActiveDay).inDays == 1) {
      newStreak++;
    } else if (today.difference(lastActiveDay).inDays > 1) {
      newStreak = 1;
    } else {
      newStreak = 1;
    }

    final newState = StreakModel(currentStreak: newStreak, lastActiveDate: now);
    state = newState;
    HiveService.saveStreak(newState);
  }

  void resetIfMissed() {
    final now = DateTime.now();
    final lastActive = state.lastActiveDate;
    final lastActiveDay = DateTime(lastActive.year, lastActive.month, lastActive.day);
    final today = DateTime(now.year, now.month, now.day);

    if (today.difference(lastActiveDay).inDays > 1) {
      final newState = StreakModel(currentStreak: 0, lastActiveDate: state.lastActiveDate);
      state = newState;
      HiveService.saveStreak(newState);
    }
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, StreakModel>((ref) {
  return StreakNotifier();
});
