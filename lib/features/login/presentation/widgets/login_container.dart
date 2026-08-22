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
  late final TextEditingController _emailTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return AuthenticationContainer(
      textFieldsList: [
        LoginCustomTextField(
          autoFocus: true,
          textInputType: .emailAddress,
          textInputAction: .next,
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          textEditingController: _emailTextEditingController,
          labelText: 'Email address',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _passwordFocusNode,
          textInputType: .visiblePassword,
          textInputAction: .done,
          textEditingController: _passwordTextEditingController,
          labelText: 'Password',
          obscureText: false,
        ),
        AppSpacing.vLg,
        Align(
          alignment: .centerStart,
          child: GestureDetector(
            //TODO: add forgot password screen
            onTap: () {},
            child: Text(
              'Forgot password?',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ),
        //
        Spacer(),
        CustomFilledButton(
          onPressed: () async {
            await ref
                .read(authProvider.notifier)
                .signInWithEmailAndPassword(
                  email: _emailTextEditingController.text.trim(),
                  password: _passwordTextEditingController.text.trim(),
                );
            final state = ref.read(authProvider);
            if (state.errorMessage == null && context.mounted) {
              context.go(AppRoutes.homePath);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Invalid Cridentials")));
            }
          },
          text: authState.isLoading ? "Logging in..." : "Login in",
        ),
      ],
    );
  }
}
