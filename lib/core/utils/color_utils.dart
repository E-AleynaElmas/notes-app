import 'package:flutter/material.dart';

class ColorUtils {
  static Color parseColor(String colorString) {
    try {
      String cleanColor = colorString.replaceAll('#', '');
      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor';
      }
      return Color(int.parse(cleanColor, radix: 16));
    } catch (e) {
      return const Color(0xFFF5F5DC);
    }
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
