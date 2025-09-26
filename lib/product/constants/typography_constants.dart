import 'package:flutter/material.dart';

TextStyle get _base => const TextStyle();

// Display 1 Styles
TextStyle get display1 => _base.copyWith(fontSize: 64);

// Display 2 Styles
TextStyle get display2 => _base.copyWith(fontSize: 56);

// Hero 1 Title Styles
TextStyle get hero1Title => _base.copyWith(fontSize: 48);

// Hero 2 Title Styles
TextStyle get hero2Title => _base.copyWith(fontSize: 40);

// H1 Styles
TextStyle get h1 => _base.copyWith(fontSize: 36);

// H2 Styles
TextStyle get h2 => _base.copyWith(fontSize: 32);

// H3 Styles
TextStyle get h3 => _base.copyWith(fontSize: 28);

// H4 Styles
TextStyle get h4 => _base.copyWith(fontSize: 24);

// H5 Styles
TextStyle get h5 => _base.copyWith(fontSize: 20);

// H6 Styles
TextStyle get h6 => _base.copyWith(fontSize: 18);

// Body XL Styles
TextStyle get bodyXL => _base.copyWith(fontSize: 16);

// Body L Styles
TextStyle get bodyL => _base.copyWith(fontSize: 14);

// Body M Styles
TextStyle get bodyM => _base.copyWith(fontSize: 13);

// Body S Styles
TextStyle get bodyS => _base.copyWith(fontSize: 12);

// Caption Styles
TextStyle get caption => _base.copyWith(fontSize: 11);

// Tiny Styles
TextStyle get tiny => _base.copyWith(fontSize: 10);

extension TextStyleExtension on TextStyle {
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);
}
