import 'package:flutter/material.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/widgets/theme_provider.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => RawMaterialButton(
    constraints: const BoxConstraints(),
    padding: const .symmetric(vertical: 16, horizontal: 48),
    shape: const StadiumBorder(side: BorderSide(width: 4, color: Colors.white)),
    fillColor: MkColors.secondaryAccent,
    onPressed: onPressed,
    child: DefaultTextStyle(style: context.theme.button, child: child),
  );
}
