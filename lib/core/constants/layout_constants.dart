import 'package:flutter/material.dart';

abstract class LayoutConstants {
  // ************* Sizes ************* //
  static const size0 = 0.0;
  static const size2 = 2.0;
  static const size4 = 4.0;
  static const size8 = 8.0;
  static const size10 = 10.0;
  static const size12 = 12.0;
  static const size16 = 16.0;
  static const size20 = 20.0;
  static const size24 = 24.0;
  static const size32 = 32.0;
  static const size40 = 40.0;
  static const size48 = 48.0;
  static const size64 = 64.0;

  // ************* Padding ************* //
  static const padding2All = EdgeInsets.all(size2);
  static const padding4All = EdgeInsets.all(size4);
  static const padding8All = EdgeInsets.all(size8);
  static const padding10All = EdgeInsets.all(size10);
  static const padding12All = EdgeInsets.all(size12);
  static const padding16All = EdgeInsets.all(size16);
  static const padding20All = EdgeInsets.all(size20);
  static const padding24All = EdgeInsets.all(size24);
  static const padding32All = EdgeInsets.all(size32);
  static const padding40All = EdgeInsets.all(size40);
  static const padding48All = EdgeInsets.all(size48);

  // ************* Vertical Padding ************* //
  static const padding2Vertical = EdgeInsets.symmetric(vertical: size2);
  static const padding4Vertical = EdgeInsets.symmetric(vertical: size4);
  static const padding8Vertical = EdgeInsets.symmetric(vertical: size8);
  static const padding12Vertical = EdgeInsets.symmetric(vertical: size12);
  static const padding16Vertical = EdgeInsets.symmetric(vertical: size16);
  static const padding20Vertical = EdgeInsets.symmetric(vertical: size20);
  static const padding24Vertical = EdgeInsets.symmetric(vertical: size24);
  static const padding32Vertical = EdgeInsets.symmetric(vertical: size32);
  static const padding40Vertical = EdgeInsets.symmetric(vertical: size40);
  static const padding48Vertical = EdgeInsets.symmetric(vertical: size48);

  // ************* Horizontal Padding ************* //
  static const padding2Horizontal = EdgeInsets.symmetric(horizontal: size2);
  static const padding4Horizontal = EdgeInsets.symmetric(horizontal: size4);
  static const padding8Horizontal = EdgeInsets.symmetric(horizontal: size8);
  static const padding12Horizontal = EdgeInsets.symmetric(horizontal: size12);
  static const padding16Horizontal = EdgeInsets.symmetric(horizontal: size16);
  static const padding20Horizontal = EdgeInsets.symmetric(horizontal: size20);
  static const padding24Horizontal = EdgeInsets.symmetric(horizontal: size24);
  static const padding32Horizontal = EdgeInsets.symmetric(horizontal: size32);
  static const padding40Horizontal = EdgeInsets.symmetric(horizontal: size40);
  static const padding48Horizontal = EdgeInsets.symmetric(horizontal: size48);

  // ************* Button Padding ************* //
  static const paddingButton = EdgeInsets.symmetric(horizontal: size16, vertical: size16);

  // ************* Empty Height ************* //
  static const emptyHeight2 = SizedBox(height: size2);
  static const emptyHeight4 = SizedBox(height: size4);
  static const emptyHeight8 = SizedBox(height: size8);
  static const emptyHeight12 = SizedBox(height: size12);
  static const emptyHeight16 = SizedBox(height: size16);
  static const emptyHeight20 = SizedBox(height: size20);
  static const emptyHeight24 = SizedBox(height: size24);
  static const emptyHeight32 = SizedBox(height: size32);
  static const emptyHeight40 = SizedBox(height: size40);
  static const emptyHeight48 = SizedBox(height: size48);

  // ************* Empty Width ************* //
  static const emptyWidth2 = SizedBox(width: size2);
  static const emptyWidth4 = SizedBox(width: size4);
  static const emptyWidth8 = SizedBox(width: size8);
  static const emptyWidth12 = SizedBox(width: size12);
  static const emptyWidth16 = SizedBox(width: size16);
  static const emptyWidth20 = SizedBox(width: size20);
  static const emptyWidth24 = SizedBox(width: size24);
  static const emptyWidth32 = SizedBox(width: size32);
  static const emptyWidth40 = SizedBox(width: size40);
  static const emptyWidth48 = SizedBox(width: size48);

  // ************* Radius ************* //
  static const radius4 = 4.0;
  static const radius8 = 8.0;
  static const radius12 = 12.0;
  static const radius14 = 14.0;
  static const radius16 = 16.0;
  static const radius20 = 20.0;
  static const radius30 = 30.0;
  static const radius60 = 60.0;

  // ************* Circular Border Radius ************* //
  static const border4Button = BorderRadius.all(Radius.circular(radius4));
  static const border8Button = BorderRadius.all(Radius.circular(radius8));
  static const border12Button = BorderRadius.all(Radius.circular(radius12));
  static const border14Button = BorderRadius.all(Radius.circular(radius14));
  static const border16Button = BorderRadius.all(Radius.circular(radius16));
  static const border20Button = BorderRadius.all(Radius.circular(radius20));
  static const border30Button = BorderRadius.all(Radius.circular(radius30));
  static const border60Button = BorderRadius.all(Radius.circular(radius60));

  // ************* Circular Border Radius ************* //
  static const topBorder20Button = BorderRadius.only(
    topLeft: Radius.circular(radius20),
    topRight: Radius.circular(radius20),
  );

  static const topBorder14Button = BorderRadius.only(
    topLeft: Radius.circular(radius14),
    topRight: Radius.circular(radius14),
  );
  // ************* Elevations ************* //
  static const elevation0 = 0.0;
  static const elevation2 = 2.0;
  static const elevation4 = 4.0;
  static const elevation6 = 6.0;
  static const elevation8 = 8.0;

  // ************* Ratios ************* //
  static const ratioWidescreen = 5 / 4;
  static const ratioFullScreen = 9 / 16;
}
