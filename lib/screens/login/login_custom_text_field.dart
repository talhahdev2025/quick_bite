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
    this._suffixIconData,
  }) : assert(
         _suffixIconData == null || _obscureText == null,
         'suffix icon and obscureText both cannot be set at same time, either remove obsureText or suffixIcon',
       );
  final TextEditingController? _textEditingController;
  final String? _labelText;
  final bool? _obscureText;
  final bool _autoFocus;
  final FocusNode? _focusNode;
  final FocusNode? _nextFocusNode;
  final TextInputAction? _textInputAction;
  final TextInputType? _textInputType;
  final IconData? _suffixIconData;

  @override
  State<LoginCustomTextField> createState() => _LoginCustomTextFieldState();
}

class _LoginCustomTextFieldState extends State<LoginCustomTextField> {
  bool? _obscureText;
  late final VoidCallback _controllerListner;
  @override
  void initState() {
    super.initState();
    _obscureText = widget._obscureText;
    _controllerListner = () {
      setState(() {});
    };
    widget._textEditingController?.addListener(_controllerListner);
  }

  @override
  void dispose() {
    widget._textEditingController?.removeListener(_controllerListner);
    super.dispose();
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
            : ((widget._textEditingController != null &&
                  widget._textEditingController!.text.isNotEmpty))
            ? IconButton(
                onPressed: () => widget._textEditingController?.clear(),
                icon: Icon(Icons.clear_rounded),
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
