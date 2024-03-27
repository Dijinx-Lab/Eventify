import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? icon;
  final Widget? trailing;
  final bool obscuretext;
  final Color borderColor;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField(
      {super.key,
      required this.controller,
      this.autofocus = false,
      this.hint = '',
      this.icon,
      this.trailing,
      this.obscuretext = false,
      this.borderColor = ColorStyle.secondaryTextColor,
      this.keyboardType = TextInputType.text,
      this.maxLength,
      this.inputFormatters,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscuretext,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: trailing,
        hintText: hint,
        fillColor: ColorStyle.whiteColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
