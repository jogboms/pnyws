import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_fonts.dart';
import 'package:pnyws/constants/mk_style.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({super.key, required super.child});

  TextStyle get xxsmall => _text10Style;

  TextStyle get xxsmallHint => xxsmall.copyWith(color: Colors.grey);

  TextStyle get xxsmallSemi => xxsmall.copyWith(fontWeight: MkStyle.semibold);

  TextStyle get xsmall => _text11Style;

  TextStyle get xsmallHint => xsmall.copyWith(color: Colors.grey);

  TextStyle get small => _text12Style;

  TextStyle get smallSemi => small.copyWith(fontWeight: MkStyle.semibold);

  TextStyle get smallButton => small.copyWith(color: MkColors.primary, fontWeight: MkStyle.bold);

  TextStyle get body1 => _text13Style;

  TextStyle get body2 => body1.copyWith(height: 1.5);

  TextStyle get body3 => _text14Style;

  TextStyle get bodyMedium => body1.copyWith(fontWeight: MkStyle.medium);

  TextStyle get bodySemi => body1.copyWith(fontWeight: MkStyle.semibold);

  TextStyle get bodyBold => body1.copyWith(fontWeight: MkStyle.bold);

  TextStyle get bodyHint => body1.copyWith(color: Colors.grey);

  TextStyle get button => bodySemi.copyWith(letterSpacing: 1);

  TextStyle get title => _text18Style;

  TextStyle get subhead1 => _text15MediumStyle;

  TextStyle get subhead1Semi => _text15SemiStyle;

  TextStyle get subhead1Bold => _text15BoldStyle;

  TextStyle get subhead1Light => _text15LightStyle;

  TextStyle get subhead2 => _text14Style;

  TextStyle get subhead3 => _text16Style;

  TextStyle get subhead3Semi => _text16Style.copyWith(fontWeight: MkStyle.semibold);

  TextStyle get subhead3Light => _text16Style.copyWith(fontWeight: MkStyle.light);

  TextStyle get headline => _text40Style.copyWith(fontWeight: MkStyle.bold);

  TextStyle get appBarTitle => display2.copyWith(fontWeight: MkStyle.semibold, letterSpacing: .35);

  TextStyle get display1 => _text20Style;

  TextStyle get display2 => _text24Style.copyWith(height: 1.05);

  TextStyle get display3 => _text28Style;

  TextStyle get display4 => _text32Style;

  TextStyle get display5 => _text34Style;

  TextStyle get textfield => _text15Style.copyWith(color: MkColors.primaryAccent);

  TextStyle get textfieldLabel => textfield.copyWith(height: 0.25, color: MkColors.lightGrey.withValues(alpha: .8));

  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  TextStyle get _text10Style => const MkFont.size(10.0);

  TextStyle get _text11Style => const MkFont.size(11.0);

  TextStyle get _text12Style => const MkFont.size(12.0);

  TextStyle get _text13Style => const MkFont.size(13.0);

  TextStyle get _text14Style => const MkFont.size(14.0);

  TextStyle get _text15Style => const MkFont.size(15.0);

  TextStyle get _text15SemiStyle => const MkFont.semibold(15.0);

  TextStyle get _text15BoldStyle => const MkFont.bold(15.0);

  TextStyle get _text15LightStyle => const MkFont.light(15.0);

  TextStyle get _text15MediumStyle => const MkFont.medium(15.0);

  TextStyle get _text16Style => const MkFont.size(16.0);

  TextStyle get _text18Style => const MkFont.size(18.0);

  TextStyle get _text20Style => const MkFont.size(20.0);

  TextStyle get _text24Style => const MkFont.size(24.0);

  TextStyle get _text28Style => const MkFont.size(28.0);

  TextStyle get _text32Style => const MkFont.size(32.0);

  TextStyle get _text34Style => const MkFont.size(34.0);

  TextStyle get _text40Style => const MkFont.light(40.0);

  static ThemeProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;

  ThemeData themeData(ThemeData theme) => ThemeData(
    primaryColor: MkColors.primary,
    brightness: Brightness.dark,
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
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: MkColors.primaryAccent,
        accentColor: MkColors.secondaryAccent,
      ),
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
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MkColors.primaryAccent,
    ).copyWith(secondary: MkColors.secondary).copyWith(surface: MkColors.primaryAccent),
  );

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => false;
}

extension TextStyleX on TextStyle {
  TextStyle get primary => copyWith(color: MkColors.primary);

  TextStyle get secondary => copyWith(color: MkColors.secondary);

  TextStyle get white => copyWith(color: MkColors.white);

  TextStyle get bold => copyWith(fontWeight: MkStyle.bold);

  TextStyle get semibold => copyWith(fontWeight: MkStyle.semibold);

  TextStyle get light => copyWith(fontWeight: MkStyle.light);

  TextStyle get medium => copyWith(fontWeight: MkStyle.medium);
}

extension BuildContextX on BuildContext {
  ThemeProvider get theme => ThemeProvider.of(this);
}
