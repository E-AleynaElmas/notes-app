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
  static Color get backgroundColor => HexColor(AppHexColors.BACKGROUND_COLOR);
  static Color get grayColor => HexColor(AppHexColors.GRAY_COLOR);
  static Color get whiteColor => HexColor(AppHexColors.WHITE_COLOR);

  static ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: _colorSchemeDark,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 17,
        fontFamily: _fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    textTheme: Theme.of(
      context,
    ).textTheme.apply(fontFamily: _fontFamily, bodyColor: primaryColor, displayColor: primaryColor),
    listTileTheme: ListTileThemeData(
      textColor: primaryColor,
      titleTextStyle: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: blackColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        textStyle: WidgetStateProperty.all(TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: blackColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: _fontFamily, color: blackColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grayColor,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: grayColor),
        borderRadius: BorderRadius.circular(12),
      ),
      hintStyle: TextStyle(color: grayColor.withValues(alpha:0.7)),
    ),
  );

  static ColorScheme get _colorSchemeDark => ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: blackColor,
    secondary: secondaryColor,
    onSecondary: primaryColor,
    tertiary: grayColor,
    error: errorColor,
    onError: blackColor,
    surface: backgroundColor,
    onSurface: primaryColor,
  );
}
