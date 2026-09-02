import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';

class LoginCustomTextField extends StatefulWidget {
  const LoginCustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.obscureText,
    this.autoFocus = false,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  final TextEditingController? controller;
  final String? labelText;
  final bool? obscureText;
  final bool autoFocus;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  @override
  State<LoginCustomTextField> createState() => _LoginCustomTextFieldState();
}

class _LoginCustomTextFieldState extends State<LoginCustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Widget? trailingIcon = widget.suffixIcon;

    if (widget.obscureText != null) {
      trailingIcon = IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    return TextFormField(
      controller: widget.controller,
      autofocus: widget.autoFocus,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: widget.prefixIcon,
        suffixIcon: trailingIcon,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider),
        ),
      ),
      onFieldSubmitted: (value) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

