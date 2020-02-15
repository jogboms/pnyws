import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_fonts.dart';

const Color kHintColor = Color(0xFFAAAAAA);
const Color kBorderSideColor = Color(0x66D1D1D1);
final Color kBorderSideErrorColor = MkColors.secondaryAccent.shade900;
const Color kTextBaseColor = MkColors.white;

const double kButtonHeight = 48.0;

class MkBorderSide extends BorderSide {
  const MkBorderSide({Color color, BorderStyle style, double width})
      : super(color: color ?? kBorderSideColor, style: style ?? BorderStyle.solid, width: width ?? 1.0);
}

class MkStyle extends TextStyle {
  const MkStyle({double fontSize, FontWeight fontWeight, Color color})
      : super(
          inherit: false,
          color: color ?? kTextBaseColor,
          fontFamily: MkFonts.base,
          fontSize: fontSize,
          fontWeight: fontWeight ?? MkStyle.regular,
          textBaseline: TextBaseline.alphabetic,
        );

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w800;
}

class MkFont extends MkStyle {
  const MkFont.size(double size) : super(fontSize: size);

  const MkFont.light(double size, [Color color]) : super(fontSize: size, fontWeight: MkStyle.light, color: color);

  const MkFont.medium(double size, [Color color]) : super(fontSize: size, fontWeight: MkStyle.medium, color: color);

  const MkFont.semibold(double size, [Color color]) : super(fontSize: size, fontWeight: MkStyle.semibold, color: color);

  const MkFont.bold(double size, [Color color]) : super(fontSize: size, fontWeight: MkStyle.bold, color: color);
}
