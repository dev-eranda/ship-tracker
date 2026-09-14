import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/core/models/user.dart';

class AuthState {
  final User? user;
  const AuthState({this.user});
  bool get isAdmin => user?.isAdmin ?? true;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void login(User user) {
    state = AuthState(user: user);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAdmin;
});
