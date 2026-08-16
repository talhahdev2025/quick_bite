import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/screens/login/authentication_container.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticationContainer(
      btnText: 'Login',
      textFieldsList: [
        LoginCustomTextField(labelText: 'Email address'),
        AppSpacing.vLg,
        LoginCustomTextField(labelText: 'Password', obscureText: false),
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
