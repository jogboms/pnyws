import 'package:flutter/cupertino.dart';

class MkNavigate {
  static PageRoute<T> slideIn<T extends Object>(Widget widget, {String? name, bool fullscreenDialog = false}) =>
      CupertinoPageRoute<T>(
        builder: (_) => widget,
        settings: name != null ? RouteSettings(name: name) : null,
        fullscreenDialog: fullscreenDialog,
      );

  static PageRoute<T> fadeIn<T extends Object>(Widget widget, {String? name, bool fullscreenDialog = false}) =>
      PageRouteBuilder<T>(
        opaque: false,
        pageBuilder: (_, _, _) => widget,
        transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
        settings: name != null ? RouteSettings(name: name) : null,
        fullscreenDialog: fullscreenDialog,
      );
}
