import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/session.dart';
import '../../services/hive_service.dart';

class SessionHistoryNotifier extends StateNotifier<List<SessionModel>> {
  SessionHistoryNotifier() : super(HiveService.getAllSessions());

  void addSession(SessionModel session) {
    state = [...state, session];
    HiveService.saveSession(session);
  }

  int getTodayFocusMinutes() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return state
        .where((s) => s.status == SessionStatus.success && s.startTime.isAfter(today))
        .fold(0, (sum, s) => sum + (s.durationSeconds ~/ 60));
  }
}

final sessionHistoryProvider = StateNotifierProvider<SessionHistoryNotifier, List<SessionModel>>((ref) {
  return SessionHistoryNotifier();
});
