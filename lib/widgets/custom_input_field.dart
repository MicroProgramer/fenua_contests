import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String hint;
  final bool isPasswordField;
  final Function(String? value)? onChange;
  final TextInputType keyboardType;
  Widget? prefix;
  int? limit;
  TextEditingController? controller;
  VoidCallback? onTap;
  bool? readOnly;
  Color? fillColor;
  int? maxLines;
  String? text;

  CustomInputField(
      {required this.hint,
      required this.isPasswordField,
      this.onChange,
      required this.keyboardType,
      this.prefix,
      this.limit,
      this.controller,
      this.onTap,
      this.readOnly,
      this.fillColor,
      this.maxLines,
      this.text});

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _isHidden;

  @override
  void initState() {
    _isHidden = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null && widget.text != null) {
      widget.controller!.text = widget.text!;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: widget.limit,
        onChanged: widget.onChange,
        obscureText: _isHidden,
        onTap: widget.onTap,
        initialValue: widget.controller == null ? widget.text : null,
        maxLines: widget.maxLines ?? 1,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        decoration: InputDecoration(
            prefixIcon: widget.prefix,
            hintText: widget.hint,
            fillColor: widget.fillColor ?? Color(0xFFECECEC),
            filled: true,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      if (widget.isPasswordField) {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      }
                    },
                    icon: Visibility(
                      visible: widget.isPasswordField,
                      child: Icon(
                        widget.isPasswordField
                            ? (_isHidden
                                ? Icons.visibility_off
                                : Icons.visibility)
                            : null,
                      ),
                    ),
                  )
                : null,
            hintStyle: TextStyle(color: Color(0xF0BDBDBD)),
            contentPadding: EdgeInsets.only(
                left: 15, right: 15, top: (widget.maxLines != null) ? 25 : 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none)
            // filled: true,
            // fillColor: Color(0xF0BBBBBB),
            ),
      ),
    );
  }
}
