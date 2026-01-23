import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_fonts.dart';

const kHintColor = Color(0xFFAAAAAA);
const kBorderSideColor = Color(0x66D1D1D1);
final kBorderSideErrorColor = MkColors.secondaryAccent.shade900;
const kButtonHeight = 48.0;
const kTextBaseColor = MkColors.white;

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({super.key, required super.child});

  TextStyle get xxsmall => const _MkStyle(fontSize: 10.0);

  TextStyle get xxsmallSemi => xxsmall.copyWith(fontWeight: .w600);

  TextStyle get small => const _MkStyle(fontSize: 12.0);

  TextStyle get body1 => const _MkStyle(fontSize: 13.0);

  TextStyle get body3 => const _MkStyle(fontSize: 14.0);

  TextStyle get bodySemi => body1.copyWith(fontWeight: .w600);

  TextStyle get bodyBold => body1.copyWith(fontWeight: .w800);

  TextStyle get button => bodySemi.copyWith(letterSpacing: 1);

  TextStyle get subhead1 => const _MkStyle(fontSize: 15.0, fontWeight: .w500);

  TextStyle get subhead1Bold => const _MkStyle(fontSize: 15.0, fontWeight: .w800);

  TextStyle get subhead3Semi => const _MkStyle(fontSize: 16.0, fontWeight: .w600);

  TextStyle get headline => const _MkStyle(fontSize: 40.0, fontWeight: .w800);

  TextStyle get appBarTitle => display2.copyWith(fontWeight: .w600, letterSpacing: .35);

  TextStyle get display2 => const _MkStyle(fontSize: 24.0).copyWith(height: 1.05);

  TextStyle get textfield => const _MkStyle(fontSize: 15.0, color: MkColors.primaryAccent);

  TextStyle get textfieldLabel => textfield.copyWith(height: 0.25, color: MkColors.lightGrey.withValues(alpha: .8));

  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  static ThemeProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;

  ThemeData themeData(ThemeData theme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: MkColors.primaryAccent,
      brightness: Brightness.dark,
      secondary: MkColors.secondary,
      surface: MkColors.primaryAccent,
    );

    return ThemeData(
      primaryColor: MkColors.primary,
      brightness: colorScheme.brightness,
      canvasColor: MkColors.primaryAccent,
      scaffoldBackgroundColor: MkColors.primary,
      iconTheme: theme.iconTheme.copyWith(color: kTextBaseColor),
      textTheme: theme.textTheme.copyWith(
        bodyMedium: theme.textTheme.bodyMedium?.merge(body1),
        labelLarge: theme.textTheme.labelLarge?.merge(button),
        titleMedium: theme.textTheme.labelLarge?.merge(subhead1),
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        height: kButtonHeight,
        colorScheme: colorScheme,
        shape: const StadiumBorder(),
        highlightColor: MkColors.secondaryAccent.shade50,
        splashColor: MkColors.primaryAccent.shade50,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MkColors.primaryAccent),
          borderRadius: BorderRadius.circular(48),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kBorderSideColor, width: 2.0),
          borderRadius: BorderRadius.circular(48),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBorderSideErrorColor),
          borderRadius: BorderRadius.circular(48),
        ),
        contentPadding: const .only(top: 13.0, bottom: 12.0),
        hintStyle: textfieldLabel,
        filled: true,
        fillColor: Colors.white,
        labelStyle: textfieldLabel,
        errorStyle: errorStyle,
      ),
      fontFamily: MkFonts.base,
      hintColor: kHintColor,
      dividerColor: kBorderSideColor,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: MkColors.secondaryAccent),
      dialogTheme: const DialogThemeData(backgroundColor: MkColors.primaryAccent),
      colorScheme: colorScheme,
    );
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => false;
}

extension BuildContextX on BuildContext {
  ThemeProvider get theme => ThemeProvider.of(this);
}

class _MkStyle extends TextStyle {
  const _MkStyle({super.fontSize, FontWeight? fontWeight, Color? color})
    : super(
        inherit: false,
        color: color ?? kTextBaseColor,
        fontFamily: MkFonts.base,
        fontWeight: fontWeight ?? .w400,
        textBaseline: .alphabetic,
      );
}
