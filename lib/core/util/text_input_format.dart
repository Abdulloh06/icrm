/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

  var dateFormat = new MaskTextInputFormatter(
    mask: '##.##.####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      var selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f =
      NumberFormat.currency(locale: 'de', decimalDigits: 0, symbol: '');
      var num = int.parse(newValue.text.replaceAll(RegExp('[^0-9]'), ''));
      final newString = f.format(num).trim();
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
