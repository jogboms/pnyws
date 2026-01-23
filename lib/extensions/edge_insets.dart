import 'package:flutter/widgets.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets scale(BuildContext context) =>
      EdgeInsets.fromLTRB(context.scale(left), context.scaleY(top), context.scale(right), context.scaleY(bottom));
}
