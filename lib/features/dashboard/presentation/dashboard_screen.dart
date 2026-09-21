import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/core/models/user.dart';
// import 'package:ship_tracker/features/auth/provider/auth_provider.dart';
import 'package:ship_tracker/features/dashboard/providers/assignment_provider.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isAdmin = ref.watch(isAdminProvider);

//     if (!isAdmin) {
//       return Scaffold(body: Center(child: Text('Access denied')));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: ListView(children: [_buildHeader(context), const Divider()]),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container();
//   }
// }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(assignmentProvider.notifier).loadInitial(),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final notifier = ref.read(assignmentProvider.notifier);
    final ok = await notifier.save();
    if (!mounted) return;
    final error = ref.read(assignmentProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Vessels assigned successfully' : (error ?? 'Failed'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(assignmentProvider);
    final notifier = ref.read(assignmentProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Vessels')),
      body: s.loading
          ? const Center(child: CircularProgressIndicator())
          : s.error != null && s.users.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: notifier.loadInitial,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _buildForm(s, notifier),
      bottomNavigationBar: s.loading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (s.selectedUser == null || s.saving)
                        ? null
                        : _submit,
                    child: s.saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Assign ${s.selectedVesselIds.length} vessel(s)',
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildForm(AssignmentState s, AssignmentNotifier notifier) {
    final filtered = s.vessels
        .where((v) => v.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    final allSelected =
        s.vessels.isNotEmpty && s.selectedVesselIds.length == s.vessels.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- User dropdown ----
          DropdownButtonFormField<User>(
            value: s.selectedUser,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Select user',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            items: s.users
                .map(
                  (u) => DropdownMenuItem(
                    value: u,
                    child: Text(u.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: notifier.selectUser,
          ),
          const SizedBox(height: 16),

          // ---- Vessel search + select all ----
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    hintText: 'Search vessels',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: s.selectedUser == null
                    ? null
                    : () => notifier.selectAll(!allSelected),
                child: Text(allSelected ? 'Clear all' : 'Select all'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ---- Vessel list ----
          Expanded(
            child: s.selectedUser == null
                ? const Center(child: Text('Select a user to assign vessels'))
                : filtered.isEmpty
                ? const Center(child: Text('No vessels found'))
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final v = filtered[i];
                      return CheckboxListTile(
                        value: s.selectedVesselIds.contains(v.id),
                        onChanged: (val) =>
                            notifier.toggleVessel(v.id, val ?? false),
                        title: Text(v.name),
                        subtitle: v.imo != null ? Text('IMO: ${v.imo}') : null,
                        secondary: const Icon(Icons.directions_boat),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
