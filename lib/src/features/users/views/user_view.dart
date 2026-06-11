import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/common/patterns/app_state_pattern.dart';
import 'package:river_pod_mvvm/src/common/state_management/state_management.dart';
import 'package:river_pod_mvvm/src/common/widgets/refresh_button_widget.dart';
import 'package:river_pod_mvvm/src/common/widgets/refresh_indicator_widget.dart';
import 'package:river_pod_mvvm/src/common/widgets/skeleton_refresh_widget.dart';
import 'package:river_pod_mvvm/src/features/settings/routes/setting_routes.dart';
import 'package:river_pod_mvvm/src/features/users/routes/user_routes.dart';
import 'package:river_pod_mvvm/src/features/users/view_models/user_view_model.dart';

class UserView extends StatefulWidget {
  final UserViewModel userViewModel;

  const UserView({super.key, required this.userViewModel});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getAllUsers();
    });
  }

  Future<void> _getAllUsers() async {
    await widget.userViewModel.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Users'),
        actions: [
          RefreshButtonWidget(
            onPressed: () async {
              await _getAllUsers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push(SettingRoutes.setting);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicatorWidget(
          onRefresh: () async {
            await _getAllUsers();
          },
          child: StateBuilderWidget<UserViewModel, UsersState>(
            viewModel: widget.userViewModel,
            builder: (context, userState) {
              return switch (userState) {
                InitialState() => const Text('List is empty.'),
                LoadingState() => ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const SkeletonRefreshWidget(),
                    );
                  },
                ),
                SuccessState(data: final users) => ListView.builder(
                  itemCount: users.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(user.name![0].toUpperCase()),
                            ),
                            title: Text(user.name ?? ''),
                            subtitle: Text(user.email ?? ''),
                          ),
                        ),
                        onTap: () {
                          context.push(UserRoutes.userDetail, extra: user);
                        },
                      ),
                    );
                  },
                ),
                ErrorState(error: final e) => Text('Error: ${e.message}'),
              };
            },
          ),
        ),
      ),
    );
  }
}
