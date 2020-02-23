import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_fonts.dart';
import 'package:pnyws/constants/mk_style.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

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

  TextStyle get textfieldLabel => textfield.copyWith(
        height: 0.25,
        color: MkColors.light_grey.withOpacity(.8),
      );

  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  TextStyle get _text10Style => MkFont.size(10.0);

  TextStyle get _text11Style => MkFont.size(11.0);

  TextStyle get _text12Style => MkFont.size(12.0);

  TextStyle get _text13Style => MkFont.size(13.0);

  TextStyle get _text14Style => MkFont.size(14.0);

  TextStyle get _text15Style => MkFont.size(15.0);

  TextStyle get _text15SemiStyle => MkFont.semibold(15.0);

  TextStyle get _text15BoldStyle => MkFont.bold(15.0);

  TextStyle get _text15LightStyle => MkFont.light(15.0);

  TextStyle get _text15MediumStyle => MkFont.medium(15.0);

  TextStyle get _text16Style => MkFont.size(16.0);

  TextStyle get _text18Style => MkFont.size(18.0);

  TextStyle get _text20Style => MkFont.size(20.0);

  TextStyle get _text24Style => MkFont.size(24.0);

  TextStyle get _text28Style => MkFont.size(28.0);

  TextStyle get _text32Style => MkFont.size(32.0);

  TextStyle get _text34Style => MkFont.size(34.0);

  TextStyle get _text40Style => MkFont.light(40.0);

  static ThemeProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ThemeProvider>();

  ThemeData themeData(ThemeData theme) {
    return ThemeData(
      accentColor: MkColors.secondary,
      primarySwatch: MkColors.primaryAccent,
      primaryColor: MkColors.primary,
      primaryColorBrightness: Brightness.dark,
      brightness: Brightness.dark,
      backgroundColor: MkColors.primaryAccent,
      canvasColor: MkColors.primaryAccent,
      dialogBackgroundColor: MkColors.primaryAccent,
      scaffoldBackgroundColor: MkColors.primary,
      iconTheme: theme.iconTheme.copyWith(color: kTextBaseColor),
      textTheme: theme.textTheme.copyWith(
        body1: theme.textTheme.body1.merge(body1),
        button: theme.textTheme.button.merge(button),
        subhead: theme.textTheme.button.merge(subhead1),
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
          borderSide: BorderSide(color: MkColors.primaryAccent, width: 1.0),
          borderRadius: BorderRadius.circular(48),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBorderSideColor, width: 2.0),
          borderRadius: BorderRadius.circular(48),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBorderSideErrorColor),
          borderRadius: BorderRadius.circular(48),
        ),
        contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
        hintStyle: textfieldLabel,
        filled: true,
        fillColor: Colors.white,
        labelStyle: textfieldLabel,
        errorStyle: errorStyle,
      ),
      cursorColor: MkColors.secondaryAccent,
      fontFamily: MkFonts.base,
      hintColor: kHintColor,
      dividerColor: kBorderSideColor,
    );
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) => false;
}
