import 'package:flutter/widgets.dart';
import "package:flutter_scale_aware/flutter_scale_aware.dart";

extension SizeX on Size {
  Size scale(BuildContext context) {
    return Size(context.scale(width), context.scaleY(height));
  }
}
