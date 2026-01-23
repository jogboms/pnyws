import 'package:flutter/widgets.dart';

class KeyboardDismissible extends StatelessWidget {
  const KeyboardDismissible({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    child: child,
  );
}
