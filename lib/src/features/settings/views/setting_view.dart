import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/di/dependency_injector.dart';
import 'package:river_pod_mvvm/src/routes/routes.dart';
import 'package:river_pod_mvvm/src/common/state_management/state_management.dart';
import 'package:river_pod_mvvm/src/features/settings/models/setting_model.dart';
import 'package:river_pod_mvvm/src/features/settings/view_models/setting_view_model.dart';

class SettingView extends ConsumerWidget {
  final SettingViewModel settingViewModel;

  const SettingView({super.key, required this.settingViewModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final userProfile = authViewModel.userProfile;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(userProfile.image),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userProfile.firstName} ${userProfile.lastName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          userProfile.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        Text(
                          '@${userProfile.username}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text('Dark theme'),
              trailing: StateBuilderWidget<SettingViewModel, SettingModel>(
                viewModel: settingViewModel,
                builder: (context, settingModel) {
                  return Switch(
                    value: settingModel.isDarkTheme,
                    onChanged: (bool isDarkTheme) {
                      settingViewModel.changeTheme(isDarkTheme: isDarkTheme);
                    },
                  );
                },
              ),
            ),
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
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
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
