import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/di/dependency_injector.dart';
import 'package:river_pod_mvvm/src/routes/routes.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final userProfile = authViewModel.userProfile;

    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Profile')),
      body: ListView(
        children: <Widget>[
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(userProfile.image)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${userProfile.firstName} ${userProfile.lastName}', style: Theme.of(context).textTheme.titleLarge),
                        Text(userProfile.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                        Text('@${userProfile.username}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Divider(),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text('Version v1.0.0')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
                  ],
                ),
              );

              if (confirm == true) {
                final authViewModel = ref.read(authViewModelProvider);
                await authViewModel.logout();
                if (context.mounted) {
                  context.go(Routes.login);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
