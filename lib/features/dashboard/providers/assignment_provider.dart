// lib/providers/assignment_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user.dart';
import '../../../core/models/vessel.dart';
import '../../../services/api_service.dart';

// ---------- Dependencies ----------

/// Plug in your real auth token source here.
final authTokenProvider = Provider<Future<String?> Function()>(
  (ref) =>
      () async => null, // TODO: return your stored token
);

final assignmentApiProvider = Provider<ApiService>((ref) {
  return ApiService(
    baseUrl: 'https://your-api.com/api', // TODO: your base URL
    getToken: ref.watch(authTokenProvider),
  );
});

// ---------- State ----------

class AssignmentState {
  final List<User> users;
  final List<Vessel> vessels;
  final User? selectedUser;
  final Set<int> selectedVesselIds;
  final bool loading;
  final bool saving;
  final String? error;

  const AssignmentState({
    this.users = const [],
    this.vessels = const [],
    this.selectedUser,
    this.selectedVesselIds = const {},
    this.loading = false,
    this.saving = false,
    this.error,
  });

  AssignmentState copyWith({
    List<User>? users,
    List<Vessel>? vessels,
    User? selectedUser,
    bool clearSelectedUser = false,
    Set<int>? selectedVesselIds,
    bool? loading,
    bool? saving,
    String? error,
    bool clearError = false,
  }) {
    return AssignmentState(
      users: users ?? this.users,
      vessels: vessels ?? this.vessels,
      selectedUser: clearSelectedUser
          ? null
          : (selectedUser ?? this.selectedUser),
      selectedVesselIds: selectedVesselIds ?? this.selectedVesselIds,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ---------- Notifier ----------

class AssignmentNotifier extends Notifier<AssignmentState> {
  ApiService get _api => ref.read(assignmentApiProvider);

  @override
  AssignmentState build() => const AssignmentState();

  Future<void> loadInitial() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final results = await Future.wait([
        _api.fetchUsers(),
        _api.fetchVessels(),
      ]);
      state = state.copyWith(
        users: results[0] as List<User>,
        vessels: results[1] as List<Vessel>,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> selectUser(User? user) async {
    if (user == null) {
      state = state.copyWith(clearSelectedUser: true, selectedVesselIds: {});
      return;
    }

    state = state.copyWith(selectedUser: user, selectedVesselIds: {});

    try {
      final ids = await _api.fetchAssignedVesselIds(user.id);
      // Guard against a stale response if the user changed while loading
      if (state.selectedUser?.id == user.id) {
        state = state.copyWith(selectedVesselIds: ids.toSet());
      }
    } catch (_) {
      // non-fatal: start with empty selection
    }
  }

  void toggleVessel(int id, bool selected) {
    final next = {...state.selectedVesselIds};
    selected ? next.add(id) : next.remove(id);
    state = state.copyWith(selectedVesselIds: next);
  }

  void selectAll(bool all) {
    state = state.copyWith(
      selectedVesselIds: all ? state.vessels.map((v) => v.id).toSet() : <int>{},
    );
  }

  Future<bool> save() async {
    final user = state.selectedUser;
    if (user == null) return false;

    state = state.copyWith(saving: true, clearError: true);
    try {
      await _api.assignVessels(user.id, state.selectedVesselIds.toList());
      state = state.copyWith(saving: false);
      return true;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      return false;
    }
  }
}

final assignmentProvider =
    NotifierProvider<AssignmentNotifier, AssignmentState>(
      AssignmentNotifier.new,
    );
