import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/screens/login/authentication_container.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({super.key});

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  late final TextEditingController _userNameTextEditingController;
  late final TextEditingController _passwordTextEditingController;
  late final TextEditingController _emailTextEditingController;

  @override
  void initState() {
    super.initState();
    _userNameTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationContainer(
      btnText: 'Sign Up',
      textFieldsList: [
        LoginCustomTextField(
          textEditingController: _userNameTextEditingController,
          autoFocus: true,
          labelText: 'User name',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          textEditingController: _emailTextEditingController,
          labelText: 'Email address',
        ),
        AppSpacing.vLg,
        LoginCustomTextField(
          textEditingController: _passwordTextEditingController,
          labelText: 'Password',
          obscureText: false,
        ),
      ],
    );
  }
}
