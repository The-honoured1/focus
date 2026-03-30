import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super('') {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('user_name') ?? '';
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    state = name;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier();
});
