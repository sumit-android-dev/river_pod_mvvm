import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/common/widgets/app_bar.dart';
import 'package:river_pod_mvvm/core/theme/color/colors.dart';
import 'package:river_pod_mvvm/core/theme/style/text_style.dart';
import 'package:river_pod_mvvm/di/providers/dependency_injector.dart';
import 'package:river_pod_mvvm/routes/routes.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final userProfile = authViewModel.userProfile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarView(title: "Settings"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (userProfile != null) _buildProfileHeader(context, userProfile),
            _buildSettingsSection(
              context,
              title: "Account",
              items: [
                _SettingItem(
                  icon: Icons.person_outline,
                  title: "Profile Information",
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.lock_outline,
                  title: "Security",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              title: "App Settings",
              items: [
                _SettingItem(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.language,
                  title: "Language",
                  trailing: Text(
                    "English",
                    style: AppTextStyle.onestRegular(textColor: AppColors.grey),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsSection(
              context,
              title: "Support",
              items: [
                _SettingItem(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.info_outline,
                  title: "About Us",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(context, ref),
            const SizedBox(height: 16),
            Text(
              "Version 1.0.0",
              style: AppTextStyle.onestRegular(
                textColor: AppColors.grey,
                textSize: 12,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic userProfile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: NetworkImage(userProfile.image),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userProfile.firstName} ${userProfile.lastName}',
                  style: AppTextStyle.onestBold(textSize: 18),
                ),
                Text(
                  userProfile.email,
                  style: AppTextStyle.onestRegular(textColor: AppColors.grey87),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '@${userProfile.username}',
                    style: AppTextStyle.onestMedium(
                      textColor: AppColors.primary,
                      textSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<_SettingItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: AppTextStyle.onestSemiBold(
              textColor: AppColors.black10,
              textSize: 16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder:
                (context, index) => const Divider(
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                  color: AppColors.greyE8,
                ),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 20, color: AppColors.black10),
                ),
                title: Text(
                  item.title,
                  style: AppTextStyle.onestMedium(textSize: 14),
                ),
                trailing:
                    item.trailing ??
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.greyAC,
                    ),
                onTap: item.onTap,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: AppColors.redED.withOpacity(0.1),
        leading: const Icon(Icons.logout, color: AppColors.redED),
        title: Text(
          "Logout",
          style: AppTextStyle.onestSemiBold(textColor: AppColors.redED),
        ),
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
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
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
}
