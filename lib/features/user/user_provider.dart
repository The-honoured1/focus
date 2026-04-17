import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState {
  final String name;
  final bool hasSeenOnboarding;
  final bool isLoading;

  UserState({
    required this.name,
    required this.hasSeenOnboarding,
    this.isLoading = false,
  });

  UserState copyWith({String? name, bool? hasSeenOnboarding, bool? isLoading}) {
    return UserState(
      name: name ?? this.name,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(name: '', hasSeenOnboarding: false, isLoading: true)) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    state = UserState(name: name, hasSeenOnboarding: hasSeenOnboarding, isLoading: false);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    state = state.copyWith(hasSeenOnboarding: true);
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    state = state.copyWith(name: name);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
