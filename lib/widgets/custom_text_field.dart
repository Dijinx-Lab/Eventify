import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? icon;
  final Widget? trailing;
  final bool obscuretext;
  final TextInputType keyboardType;
  const CustomTextField(
      {super.key,
      required this.controller,
      this.hint = '',
      this.icon,
      this.trailing,
      this.obscuretext = false,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscuretext,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: trailing,
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorStyle.secondaryTextColor),
              borderRadius: BorderRadius.circular(15))),
    );
  }
}
