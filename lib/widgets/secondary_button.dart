import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key key,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minHeight: 0),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
      shape: StadiumBorder(
        side: MkBorderSide(width: 4, color: Colors.white),
      ),
      fillColor: MkColors.secondaryAccent,
      child: DefaultTextStyle(child: child, style: context.theme.button),
      onPressed: onPressed,
    );
  }
}
