import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputFormattingUtils {
  static TextInputFormatter numbersOnly() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  static TextInputFormatter addCurrencyBreaks() {
    return SpaceSeparatedInputFormatter();
  }
}

class SpaceSeparatedInputFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,###", "en_US");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Format the input text using NumberFormat
    String formattedValue = formatter.format(parseInput(newValue.text));

    // Replace commas with spaces
    formattedValue = formattedValue.replaceAll(",", " ");

    // Calculate the cursor position after formatting
    int cursorPosition = getCursorPosition(oldValue, newValue, formattedValue);

    // Set the new text value with the cursor position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // Helper function to parse input text by removing non-numeric characters
  int parseInput(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  // Helper function to calculate the cursor position after formatting
  int getCursorPosition(TextEditingValue oldValue, TextEditingValue newValue,
      String formattedValue) {
    // If the length of the new value is greater than the old value,
    // the cursor is likely moving forward, so keep it at the same relative position
    if (newValue.text.length > oldValue.text.length) {
      return newValue.selection.baseOffset;
    }

    // If the length is the same or decreasing, calculate the new cursor position
    int cursorPosition = newValue.selection.baseOffset;

    // Adjust cursor position based on the difference in lengths
    cursorPosition += formattedValue.length - newValue.text.length;

    // Ensure the cursor position is within valid bounds
    cursorPosition = cursorPosition.clamp(0, formattedValue.length);

    return cursorPosition;
  }
}
