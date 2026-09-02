import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';

class AuthenticationContainer extends StatelessWidget {
  const AuthenticationContainer({
    super.key,
    required this.textFieldsList,
  });

  final List<Widget> textFieldsList;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: AppInsets.card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vMd,
              ...textFieldsList,
              AppSpacing.vLg,
            ],
          ),
        ),
      ),
    );
  }
}

