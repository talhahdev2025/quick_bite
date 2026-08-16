import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';

class LoginCustomTextField extends StatefulWidget {
  const LoginCustomTextField({
    super.key,
    this._textEditingController,
    this._labelText,
    this._obscureText,
    this._autoFocus = false,
    this._focusNode,
    this._nextFocusNode,
    this._textInputAction,
    this._textInputType,
  });
  final TextEditingController? _textEditingController;
  final String? _labelText;
  final bool? _obscureText;
  final bool _autoFocus;
  final FocusNode? _focusNode;
  final FocusNode? _nextFocusNode;
  final TextInputAction? _textInputAction;
  final TextInputType? _textInputType;

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
      focusNode: widget._focusNode,
      textInputAction: widget._textInputAction,
      obscureText: _obscureText ?? false,
      keyboardType: widget._textInputType,
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
      onSubmitted: (value) {
        if (widget._nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget._nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
