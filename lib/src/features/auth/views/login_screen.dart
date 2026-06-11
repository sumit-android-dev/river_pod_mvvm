import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/src/common/dependency_injectors/dependency_injector.dart';
import 'package:river_pod_mvvm/src/common/patterns/app_state_pattern.dart';
import 'package:river_pod_mvvm/src/common/routes/routes.dart';
import 'package:river_pod_mvvm/src/features/auth/models/auth_model.dart';
import 'package:river_pod_mvvm/src/features/auth/exceptions/auth_exception.dart';
import 'package:river_pod_mvvm/src/features/auth/view_models/auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserSession();
    });
  }

  /// Checks if the user is already logged in
  Future<void> checkUserSession() async {
    final viewModel = ref.read(authViewModelProvider);
    bool isLogin = await viewModel.isLogin();
    if (isLogin) {
      routeToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(authViewModelProvider);
    final state = viewModel.state;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    );

    // Listen for state changes to handle navigation or errors
    ref.listen(authViewModelProvider.select((vm) => vm.state), (previous, next) {
      if (next is SuccessState) {
        routeToHomeScreen();
      } else if (next is ErrorState<AuthModel, AuthException>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: border,
                  ),
                  initialValue: viewModel.signInRequest.username,
                  onChanged: (value) {
                    viewModel.signInRequest.username = value;
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: _obscurePassword,
                  initialValue: viewModel.signInRequest.password,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: border,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    viewModel.signInRequest.password = value;
                  },
                ),
                const SizedBox(height: 32.0),
                buildSignInButton(viewModel),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (state is LoadingState)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// Builds the sign-in button with validation
  Widget buildSignInButton(AuthViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 55.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () {
          final validation = viewModel.canSendSignInRequest();
          if (validation.$1) {
            viewModel.login();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(validation.$2)),
            );
          }
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Routes to the home screen after successful login or auto-login
  void routeToHomeScreen() {
    context.go(Routes.home);
  }
}
