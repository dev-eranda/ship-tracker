import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/core/models/user.dart';
import 'package:ship_tracker/core/models/vessel.dart';
import 'package:ship_tracker/features/Profile/provider/vessel_provider.dart';
import 'package:ship_tracker/features/auth/provider/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final vesselsAsync = ref.watch(assignedVesselsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : RefreshIndicator(
              onRefresh: () => ref.refresh(assignedVesselsProvider.future),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _UserCard(user: user),
                  const SizedBox(height: 24),
                  Text(
                    'Assign Vessels',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  vesselsAsync.when(
                    data: (vessels) => vessels.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('No vessels assigned'),
                          )
                        : Column(
                            children: vessels
                                .map((v) => _VesselTile(vessel: v))
                                .toList(),
                          ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Failed to load vessels: $err'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VesselTile extends StatelessWidget {
  final Vessel vessel;
  const _VesselTile({required this.vessel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.directions_boat_outlined),
        title: Text(vessel.name),
        subtitle: Text('IMO: ${vessel.imo}'),
        trailing: Chip(
          label: Text(vessel.status.label),
          backgroundColor: vessel.status == 'Active'
              ? Colors.green.withOpacity(0.15)
              : Colors.grey.withOpacity(0.15),
        ),
      ),
    );
  }
}
