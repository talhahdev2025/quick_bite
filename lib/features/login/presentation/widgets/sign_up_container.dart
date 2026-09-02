import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/router/app_routes.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/login/presentation/widgets/authentication_container.dart';
import 'package:quick_bite/features/login/presentation/widgets/login_custom_text_field.dart';

class SignUpContainer extends ConsumerStatefulWidget {
  const SignUpContainer({super.key});

  @override
  ConsumerState<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends ConsumerState<SignUpContainer> {
  late final TextEditingController _userNameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  late final FocusNode _userNameFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _userNameController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    await ref.read(authProvider.notifier).createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

    if (!mounted) return;

    final state = ref.read(authProvider);
    if (state.errorMessage == null && state.isLoggedIn) {
      if (username.isNotEmpty && state.user != null) {
        await state.user!.updateDisplayName(username);
      }
      if (!mounted) return;
      context.go(AppRoutes.homePath);
    } else if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? 'Signup failed'),
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
          focusNode: _userNameFocusNode,
          nextFocusNode: _emailFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: _userNameController,
          autoFocus: true,
          labelText: 'User name',
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          labelText: 'Email address',
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          controller: _passwordController,
          labelText: 'Password',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
        ),
        AppSpacing.vXl,
        CustomFilledButton(
          isLoading: authState.isLoading,
          onPressed: _handleSignUp,
          text: 'Sign Up',
        ),
      ],
    );
  }
}

