import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';

class LoginCustomTextField extends StatefulWidget {
  const LoginCustomTextField({
    super.key,
    this._textEditingController,
    this._labelText,
    this._obscureText,
    this._autoFocus = false,
  });
  final TextEditingController? _textEditingController;
  final String? _labelText;
  final bool? _obscureText;
  final bool _autoFocus;

  @override
  State<LoginCustomTextField> createState() => _LoginCustomTextFieldState();
}

class _LoginCustomTextFieldState extends State<LoginCustomTextField> {
  bool? _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget._obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textEditingController,
      autofocus: widget._autoFocus,
      decoration: InputDecoration(
        label: widget._labelText != null ? Text(widget._labelText!) : null,
        suffixIcon: (_obscureText != null)
            ? IconButton(
                onPressed: () => setState(() {
                  _obscureText = !_obscureText!;
                }),
                icon: Icon(
                  _obscureText!
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
        //focused border
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      obscureText: _obscureText ?? false,
    );
  }
}
