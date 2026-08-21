import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/features/login/widgets/authentication_container.dart';
import 'package:quick_bite/features/login/widgets/login_custom_text_field.dart';

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({super.key});

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
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
    return AuthenticationContainer(
      btnText: 'Sign Up',
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
      ],
    );
  }
}
