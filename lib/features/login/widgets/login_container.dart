import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/login/widgets/authentication_container.dart';
import 'package:quick_bite/features/login/widgets/login_custom_text_field.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
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
    return AuthenticationContainer(
      btnText: 'Login',
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
      ],
    );
  }
}
