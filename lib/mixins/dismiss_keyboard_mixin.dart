import 'package:flutter/widgets.dart';

mixin DismissKeyboardMixin {
  BuildContext get context;

  void closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}
