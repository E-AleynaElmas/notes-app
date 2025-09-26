import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/hex_color.dart';
import 'app_colors.dart';

class ThemeStyles {
  static const String _fontFamily = 'Satoshi';

  static Color get primaryColor => HexColor(AppHexColors.PRIMARY_COLOR);
  static Color get secondaryColor => HexColor(AppHexColors.SECONDARY_COLOR);
  static Color get warningColor => HexColor(AppHexColors.WARNING_COLOR);
  static Color get errorColor => HexColor(AppHexColors.ERROR_COLOR);
  static Color get blackColor => HexColor(AppHexColors.BLACK_COLOR);
  static Color get backgroundColor => HexColor(AppHexColors.LIGHT_THEME_BACKGROUND);
  static Color get grayColor => HexColor(AppHexColors.GRAY_COLOR);

  static ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: _colorSchemeLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: backgroundColor),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: backgroundColor,
        fontWeight: FontWeight.bold,
        fontSize: 17,
        fontFamily: _fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    textTheme: Theme.of(
      context,
    ).textTheme.apply(fontFamily: _fontFamily, bodyColor: blackColor, displayColor: blackColor),
    listTileTheme: ListTileThemeData(
      textColor: blackColor,
      titleTextStyle: TextStyle(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: backgroundColor,
      foregroundColor: primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: backgroundColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: secondaryColor,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ColorScheme get _colorSchemeLight => ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: backgroundColor,
    secondary: secondaryColor,
    onSecondary: blackColor,
    tertiary: grayColor,
    error: errorColor,
    onError: errorColor,
    surface: warningColor,
    onSurface: warningColor,
  );
}
