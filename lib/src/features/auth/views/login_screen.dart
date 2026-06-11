/*
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final viewModel = GetIt.instance<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    checkUserSession();
  }

  /// Checks if the user is already logged in
  checkUserSession() async {
    final authSession = AuthSession().isLogin();
    bool isLogin = await authSession;
    if (isLogin) {
      routeToHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    );

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
                  'Email Address',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: border,
                  ),
                  initialValue: viewModel.signInRequest.emailAddress,
                  onChanged: (value) {
                    viewModel.signInRequest.emailAddress = value;
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
                    hintStyle: TextStyle(color: Colors.grey),
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
                buildSignInButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          BlocConsumer(
            bloc: viewModel.authBloc,
            builder: (context, state) {
              return handleBlocStateWithWidget(
                state: state,
                loading: () {
                  state as AuthLoading;
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                error: (state) => const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
            listener: (context, state) {
              handleBlocState(
                state: state,
                onSuccess: (state) {
                  routeToHomeScreen();
                },
                onError: (state) {
                  state as AuthError;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the sign-in button with validation
  Widget buildSignInButton() {
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
          if (viewModel.canSendSignInRequest().$1) {
            viewModel.signIn();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(viewModel.canSendSignInRequest().$2)),
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
  routeToHomeScreen() {

  }
}*/
