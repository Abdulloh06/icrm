/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

  var dateFormat = new MaskTextInputFormatter(
    mask: '##.##.####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

