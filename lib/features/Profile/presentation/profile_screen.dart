import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/core/models/vessel.dart';
import 'package:ship_tracker/features/Profile/provider/vessel_provider.dart';
import 'package:ship_tracker/features/auth/provider/auth_provider.dart';

Color _getVesselStatusColor(VesselStatus status) {
  return switch (status) {
    VesselStatus.active => Colors.green,
    VesselStatus.docked => Colors.black,
  };
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final vesselsAsync = ref.watch(assignedVesselsProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          _buildHeader(context),
          const Divider(),

          _buildSection(
            context,
            title: 'Vessels',
            children: [
              vesselsAsync.when(
                data: (vessels) {
                  if (vessels.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        'No vessels assigned',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final vessel in vessels)
                        _buildVesselTile(
                          context,
                          vessel: vessel,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getVesselStatusColor(vessel.status)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              vessel.status.label,
                              style: TextStyle(
                                color: _getVesselStatusColor(vessel.status),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ),
                    ],
                  );
                },

                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Loading vessels...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                error: (err, stack) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Failed to load vessels: $err'),
                ),
              ),
            ],
          ),

          _buildSection(
            context,
            title: 'Security',
            children: [
              _buildSettingTile(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Last change 30 days ago',
                onTap: () {},
              ),
              _buildSettingTile(
                context,
                icon: Icons.key,
                title: 'Active Sessions',
                subtitle: '2 devices',
                onTap: () {},
              ),
              _buildSettingTile(
                context,
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out from all devices',
                textColor: Colors.red.withValues(alpha: 0.8),
                onTap: () {},
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'john.doe@email.com',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: title == 'Danger Zone'
                  ? Colors.red.withValues(alpha: 0.8)
                  : Colors.grey[60],
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: textColor ?? Colors.blue),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildVesselTile(
    BuildContext context, {
    required Vessel vessel,
    Color? textColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.directions_boat_filled,
          color: textColor ?? Colors.blue,
        ),
      ),
      title: Text(vessel.name, style: TextStyle(color: textColor)),
      subtitle: Text(
        'MMSI: ${vessel.mmsi}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
