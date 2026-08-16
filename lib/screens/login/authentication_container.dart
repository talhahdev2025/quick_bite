import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';

class AuthenticationContainer extends StatelessWidget {
  const AuthenticationContainer({
    super.key,
    required this.textFieldsList,
    required this._btnText,
  });
  final List<Widget> textFieldsList;
  final String _btnText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.card,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Column(
        children: [
          AppSpacing.vLg,
          ...textFieldsList,
          Spacer(),
          CustomFilledButton(onPressed: () {}, text: _btnText),
        ],
      ),
    );
  }
}
