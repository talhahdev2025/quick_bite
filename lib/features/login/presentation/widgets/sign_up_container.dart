import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  late final TextEditingController _userNameTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  late final TextEditingController _emailTextEditingController;
  late final FocusNode _userNameFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _userNameTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _userNameFocusNode.dispose();
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
          focusNode: _userNameFocusNode,
          nextFocusNode: _emailFocusNode,
          textInputType: .name,
          textInputAction: .next,
          textEditingController: _userNameTextEditingController,
          autoFocus: true,
          labelText: 'User name',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _emailFocusNode,
          nextFocusNode: _passwordFocusNode,
          textInputAction: .next,
          textInputType: .emailAddress,
          textEditingController: _emailTextEditingController,
          labelText: 'Email address',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          focusNode: _passwordFocusNode,
          textInputAction: .done,
          textInputType: .visiblePassword,
          textEditingController: _passwordTextEditingController,
          labelText: 'Password',
          obscureText: false,
        ),
        //
        Spacer(),
        CustomFilledButton(
          onPressed: () async {
            await ref
                .read(authProvider.notifier)
                .createUserWithEmailAndPassword(
                  email: _emailTextEditingController.text.trim(),
                  password: _passwordTextEditingController.text.trim(),
                );

            final state = ref.read(authProvider);
            if (state.errorMessage == null && context.mounted) {
              context.go(AppRoutes.homePath);
            }
          },
          text:authState.isLoading?"creating..." : "Sign Up",
        ),
      ],
    );
  }
}
