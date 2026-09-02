import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader.name({super.key, required this.header});
  final String header;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(header, style: AppTextStyles.headlineMedium)],
    );
  }
}
