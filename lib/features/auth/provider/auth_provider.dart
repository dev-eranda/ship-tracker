import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { admin, user, guest }

class AppUser {
  final String id;
  final String name;
  final UserRole role;
  const AppUser({required this.id, required this.name, required this.role});
  bool get isAdmin => role == UserRole.admin;
}

class AuthState {
  final AppUser? user;
  const AuthState({this.user});
  bool get isAdmin => user?.isAdmin ?? true;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void login(AppUser user) {
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
