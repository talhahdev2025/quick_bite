import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/login/presentation/widgets/authentication_container.dart';
import 'package:quick_bite/features/login/presentation/widgets/login_custom_text_field.dart';

class LoginContainer extends ConsumerStatefulWidget {
  const LoginContainer({super.key});

  @override
  ConsumerState<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends ConsumerState<LoginContainer> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await ref.read(authProvider.notifier).signInWithEmailAndPassword(
          email: email,
          password: password,
        );

    if (!mounted) return;

    final state = ref.read(authProvider);
    if (state.errorMessage == null && state.isLoggedIn) {
      context.go(AppRoutes.homePath);
    } else if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Invalid credentials'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AuthenticationContainer(
      textFieldsList: [
        LoginCustomTextField(
          autoFocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          controller: _emailController,
          labelText: 'Email address',
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _passwordFocusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          controller: _passwordController,
          labelText: 'Password',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
        ),
        AppSpacing.vMd,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset link feature coming soon!')),
              );
            },
            child: Text(
              'Forgot password?',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        AppSpacing.vLg,
        CustomFilledButton(
          isLoading: authState.isLoading,
          onPressed: _handleLogin,
          text: 'Log in',
        ),
      ],
    );
  }
}

