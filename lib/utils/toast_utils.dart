import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class ToastUtils {
  static showCustomSnackbar({
    required BuildContext context,
    required String contentText,
    Icon? icon,
    String? subText,
    int millisecond = 4000,
    Color background = ColorStyle.primaryColorLight,
    bool isCenteredText = false,
  }) {
    bool isExecute = true;
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const SizedBox(
                  width: 0,
                  height: 0,
                ),
          icon != null
              ? const SizedBox(
                  width: 10,
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          Expanded(
            child: Text(
              contentText,
              textAlign: isCenteredText ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                  color: ColorStyle.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: background,
      duration: Duration(milliseconds: millisecond),
      behavior: SnackBarBehavior.fixed,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);

    /*Timer(Duration(seconds: second), () {
      if (isExecute) afterExecuteMethod();
    });*/
  }
}
