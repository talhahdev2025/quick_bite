import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';

class AuthenticationContainer extends StatelessWidget {
  const AuthenticationContainer({super.key,required this.textFieldsList});
  final List<Widget> textFieldsList;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.card,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Column(
        children: [
          AppSpacing.vLg,
          ...textFieldsList,
          AppSpacing.vLg,
          Align(
            alignment: .centerStart,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot password?',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
          Spacer(),
          CustomFilledButton(onPressed: () {}, text: 'Login'),
        ],
      ),
    );
  }
}
