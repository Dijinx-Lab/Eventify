import 'dart:math';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class NameAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;

  const NameAvatar(
      {super.key, required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    String initials = _getInitials(firstName, lastName);

    return CircleAvatar(
      radius: 40,
      backgroundColor: ColorStyle.primaryColorExtraLight,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
            fontSize: 24,
            color: ColorStyle.primaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    String secondInitial = lastName.isNotEmpty
        ? lastName[0]
        : (firstName.length > 1 ? firstName[1] : '');

    return '$firstInitial$secondInitial';
  }
}
