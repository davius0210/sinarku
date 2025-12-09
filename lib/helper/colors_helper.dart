import 'package:flutter/widgets.dart';

class ColorsHelper {
  static const Color primary = Color(0xFF0A4775);
  static const Color secondary = Color(0xFF25D366);
  static const Color third = Color(0xFFEEEEEE);
  static const Color blue = Color(0xFF4CB3CF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color hint = Color(0xFF828282);
  static const Color buttonGrey = Color(0xFF828282);
  static const Color buttonGreyDark = Color.fromARGB(255, 77, 76, 76);
  static const Color disable = Color(0xFF828282);
  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFDC3545), Color(0xFFC82333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFE0A800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF28A745), Color(0xFF218838)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF17A2B8), Color(0xFF138496)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
