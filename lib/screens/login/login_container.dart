import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/screens/login/authentication_container.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  late final TextEditingController _emailTextEditingController;
  late final TextEditingController _passwordTextEditingController;

  @override
  void initState() {
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationContainer(
      btnText: 'Login',
      textFieldsList: [
        LoginCustomTextField(
          autoFocus: true,
          textEditingController: _emailTextEditingController,
          labelText: 'Email address',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          textEditingController: _passwordTextEditingController,
          labelText: 'Password',
          obscureText: false,
        ),
        AppSpacing.vLg,
        Align(
          alignment: .centerStart,
          child: GestureDetector(
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
