import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/features/Profile/provider/dev_users.dart';
import 'package:ship_tracker/features/auth/provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose test user')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: DevUsers.all.map((user) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                ),
              ),
              title: Text(user.name),
              subtitle: Text(user.role.name.toUpperCase()),
              onTap: () {
                ref.read(authProvider.notifier).login(user);
                if (!context.mounted) return;
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
