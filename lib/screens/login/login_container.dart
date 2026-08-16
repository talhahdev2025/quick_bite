import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/screens/login/authentication_container.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';
class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticationContainer(
              textFieldsList: [
                LoginCustomTextField(labelText: 'Email address'),
                AppSpacing.vLg,
                LoginCustomTextField(labelText: 'Password', obscureText: false),
              ],
            );
  }
}