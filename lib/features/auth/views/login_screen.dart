import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:river_pod_mvvm/common/widgets/app_logo.dart';
import 'package:river_pod_mvvm/core/theme/color/colors.dart';
import 'package:river_pod_mvvm/core/theme/style/text_style.dart';
import 'package:river_pod_mvvm/di/providers/dependency_injector.dart';
import 'package:river_pod_mvvm/features/auth/exceptions/auth_exception.dart';
import 'package:river_pod_mvvm/features/auth/models/auth_model.dart';
import 'package:river_pod_mvvm/features/auth/view_models/auth_view_model.dart';
import 'package:river_pod_mvvm/patterns/app_state_pattern.dart';
import 'package:river_pod_mvvm/routes/routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(authViewModelProvider);
    final state = viewModel.state;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none);

    /// Listen for state changes to handle navigation or errors
    ref.listen(authViewModelProvider.select((vm) => vm.state), (previous, next) {
      if (next is SuccessState) {
        routeToHomeScreen();
      } else if (next is ErrorState<AuthModel, AuthException>) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Center(child: AppLogo(size: 140)),
                  Center(
                    child: Text("River Pod", style: AppTextStyle.onestSemiBold(textColor: AppColors.black, textSize: 24.0)),
                  ),
                  const SizedBox(height: 24.0),
                  Text('Username', style: AppTextStyle.onestMedium(textColor: AppColors.black, textSize: 14.0)),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: AppTextStyle.onestRegular(textColor: AppColors.black, textSize: 16.0),
                    decoration: InputDecoration(
                      hintText: 'Enter username',
                      hintStyle: AppTextStyle.onestRegular(textColor: AppColors.grey, textSize: 16.0),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: border,
                    ),
                    initialValue: viewModel.signInRequest.username,
                    onChanged: (value) {
                      viewModel.signInRequest.username = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Text('Password', style: AppTextStyle.onestMedium(textColor: AppColors.black, textSize: 14.0)),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: _obscurePassword,
                    style: AppTextStyle.onestRegular(textColor: AppColors.black, textSize: 16.0),
                    initialValue: viewModel.signInRequest.password,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: AppTextStyle.onestRegular(textColor: AppColors.grey, textSize: 16.0),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      border: border,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
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
                  _buildSignInButton(viewModel, colorScheme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (state is LoadingState)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
            ),
        ],
      ),
    );
  }

  /// Builds the sign-in button with validation
  Widget _buildSignInButton(AuthViewModel viewModel, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 55.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        onPressed: () {
          final validation = viewModel.canSendSignInRequest();
          if (validation.$1) {
            viewModel.login();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(validation.$2)));
          }
        },
        child: Text('Sign In', style: AppTextStyle.onestSemiBold(textColor: AppColors.white, textSize: 18.0)),
      ),
    );
  }

  /// Routes to the home screen after successful login or auto-login
  void routeToHomeScreen() {
    context.go(Routes.home);
  }
}
