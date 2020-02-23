import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
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
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      shape: StadiumBorder(),
      fillColor: MkColors.secondaryAccent,
      child: DefaultTextStyle(child: child, style: ThemeProvider.of(context).button),
      onPressed: onPressed,
    );
  }
}
