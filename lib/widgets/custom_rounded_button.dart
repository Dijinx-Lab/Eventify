import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String buttonText;
  final Function onTap;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;
  final Color buttonBackgroundColor;
  final double roundedCorners;
  final double elevation;
  final bool isEnabled;
  final Color borderColor;

  const CustomRoundedButton(
    this.buttonText,
    this.onTap, {
    Key? key,
    this.textColor = Colors.white,
    this.textSize = 16.0,
    this.textWeight = FontWeight.w400,
    this.buttonBackgroundColor = ColorStyle.primaryColor,
    this.roundedCorners = 10,
    this.elevation = 0.0,
    this.isEnabled = true,
    this.borderColor = ColorStyle.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return 0;
              }
              return elevation;
            },
          ),
          overlayColor: MaterialStateProperty.all<Color>(
              isEnabled ? Colors.black12 : Colors.transparent),
          backgroundColor: MaterialStateProperty.all<Color>(isEnabled
              ? buttonBackgroundColor
              : buttonBackgroundColor.withOpacity(0.3)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(roundedCorners),
                  side: BorderSide(color: borderColor)))),
      onPressed: () {
        if (isEnabled) onTap();
      },
      child: Text(
        buttonText,
        style: TextStyle(
            height: 1.2,
            fontSize: textSize,
            color: textColor,
            fontWeight: textWeight),
      ),
    );
  }
}
