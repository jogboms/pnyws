import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_aware/flutter_scale_aware.dart';

class ScaledBox extends StatelessWidget {
  const ScaledBox({super.key, this.width = 0, this.height = 0, this.child});

  const ScaledBox.vertical(this.height, {super.key}) : width = 0, child = null;

  const ScaledBox.horizontal(this.width, {super.key}) : height = 0, child = null;

  final double width;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: context.scale(width), height: context.scaleY(height), child: child);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(DiagnosticsProperty<Widget>('child', child));
  }
}
