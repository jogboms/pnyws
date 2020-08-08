import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pnyws/constants/mk_colors.dart';
import 'package:pnyws/constants/mk_style.dart';
import 'package:pnyws/data/data.dart';
import 'package:pnyws/screens/home/interpolate.dart';
import 'package:pnyws/utils/utils.dart';

const kBarWidth = 44.0;
const kBarSpacing = 4.0;
const kLabelHeight = 32.0;
const kTrackHeight = 32.0;
const kStrokeWidth = 4.0;

class GraphView extends BoxScrollView {
  const GraphView({
    Key key,
    @required this.values,
    @required this.animation,
  }) : super(key: key, scrollDirection: Axis.horizontal);

  final List<ExpenseData> values;
  final Animation<double> animation;

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverToBoxAdapter(child: GraphWidget(animation: animation, values: values));
  }
}

class GraphWidget extends LeafRenderObjectWidget {
  const GraphWidget({
    Key key,
    @required this.values,
    @required this.animation,
  }) : super(key: key);

  final List<ExpenseData> values;
  final Animation<double> animation;

  @override
  RenderGraphBox createRenderObject(BuildContext context) {
    return RenderGraphBox(values: values, animation: animation);
  }

  @override
  void updateRenderObject(BuildContext context, RenderGraphBox renderObject) {
    renderObject..values = values;
  }
}

class GraphParentData extends ContainerBoxParentData<GraphItemBar> {}

class RenderGraphBox extends RenderBox
    with
        ContainerRenderObjectMixin<GraphItemBar, GraphParentData>,
        RenderBoxContainerDefaultsMixin<GraphItemBar, GraphParentData> {
  RenderGraphBox({@required List<ExpenseData> values, @required this.animation}) {
    _values = normalizeValues(values);
    addChildren(_values);
  }

  Animation<double> animation;

  List<ExpenseData> _values;

  List<ExpenseData> get values => _values;

  set values(List<ExpenseData> values) {
    final normalized = normalizeValues(values);
    if (_values == normalized) {
      return;
    }
    _values = normalized;
    removeAll();
    addChildren(_values);
    markNeedsLayout();
  }

  List<ExpenseData> normalizeValues(List<ExpenseData> values) {
    return groupReduceBy<ExpenseData>(
      values,
      (item) => item.createdAt.day.toString(),
      (a, b) => ExpenseData(title: "", value: a.value + b.value, createdAt: b.createdAt),
    );
  }

  List<T> groupReduceBy<T extends ExpenseData>(List<T> list, String Function(T) fn, T Function(T a, T b) reducer) {
    return list
        .fold<Map<String, List<T>>>(<String, List<T>>{}, (rv, T x) {
          final key = fn(x);
          (rv[key] = rv[key] ?? <T>[]).add(x);
          return rv;
        })
        .map<String, T>((key, values) => MapEntry(key, values.reduce(reducer)))
        .values
        .toList();
  }

  void addChildren(List<ExpenseData> values) {
    addAll(values.map((item) => GraphItemBar(value: item.value)).toList());
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GraphParentData) {
      child.parentData = GraphParentData();
    }
  }

  @override
  BoxConstraints get constraints => super.constraints.copyWith(maxWidth: childCount * kBarWidth);

  @override
  void performLayout() {
    final maxHeight = constraints.maxHeight - kTrackHeight - kLabelHeight;
    final maxValue = values.isEmpty ? 0 : values.map((item) => item.value).reduce(math.max);

    GraphItemBar child = firstChild;
    int childCount = 0;
    while (child != null) {
      final height = interpolate(inputMax: maxValue, input: child.value, outputMax: maxHeight);
      child.layout(BoxConstraints.tight(Size(kBarWidth - kBarSpacing, height)), parentUsesSize: true);

      final GraphParentData childParentData = child.parentData;
      childParentData.offset = Offset(childCount * kBarWidth, maxHeight - height + kLabelHeight);

      child = childParentData.nextSibling;
      childCount++;
    }

    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    animation.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    animation.removeListener(markNeedsLayout);

    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    GraphItemBar child = firstChild;
    Offset prevCenterTop;
    const resolvedChildRadius = (kBarWidth - kBarSpacing) / 2;
    final points = <Offset>[];
    final path = Path();

    while (child != null) {
      final GraphParentData childParentData = child.parentData;
      final resolvedChildOffset = childParentData.offset + offset;
      context.paintChild(child, resolvedChildOffset);

      final centerTop = Offset(resolvedChildOffset.dx + resolvedChildRadius, resolvedChildOffset.dy);

      if (prevCenterTop == null) {
        path.moveTo(centerTop.dx, centerTop.dy);
        prevCenterTop = centerTop;
      }

      points.add(centerTop);

      final anchor = (prevCenterTop + centerTop) / 2;
      final pointA = (anchor + prevCenterTop) / 2;
      final pointB = (anchor + centerTop) / 2;
      path.quadraticBezierTo(pointA.dx, prevCenterTop.dy, anchor.dx, anchor.dy);
      path.quadraticBezierTo(pointB.dx, centerTop.dy, centerTop.dx, centerTop.dy);

      child = childParentData.nextSibling;
      prevCenterTop = centerTop;
    }

    context.canvas.drawPath(
      Path()..addPath(path, Offset(-1, kStrokeWidth * 2)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = kStrokeWidth
        ..color = Colors.black87
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, kStrokeWidth)
        ..strokeCap = StrokeCap.round,
    );

    final rect = offset & size;
    context.canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = kStrokeWidth * animation.value
        ..shader = ui.Gradient.linear(
          rect.centerLeft,
          rect.centerRight,
          [MkColors.secondaryAccent, Colors.yellowAccent, Colors.purpleAccent, Colors.redAccent],
          [.25, .5, .75, 1],
        ),
    );

    for (var i = 0; i < points.length; i++) {
      final point = points[i];

      context.canvas.drawCircle(
        point,
        kStrokeWidth * 2 * animation.value,
        Paint()
          ..color = Colors.white38
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, kStrokeWidth),
      );
      context.canvas.drawCircle(point, kStrokeWidth * animation.value / 1.6, Paint()..color = Colors.white);

      const labelTextMargin = kStrokeWidth * 2;
      final labelTextRect = Offset(point.dx - kBarWidth / 2, constraints.maxHeight + labelTextMargin - kTrackHeight) &
          Size(kBarWidth, kTrackHeight - labelTextMargin);
      final createdAt = values[i].createdAt;
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        textWidthBasis: TextWidthBasis.longestLine,
        text: TextSpan(
          text: '${createdAt.day}.${createdAt.month}.${createdAt.year.toString().substring(2)}',
          style: TextStyle(
            color: MkColors.primaryAccent.shade500,
            fontSize: 8,
            fontWeight: MkStyle.semibold,
            shadows: [ui.Shadow(blurRadius: 2, offset: const Offset(0, 1))],
          ),
        ),
      )..layout(maxWidth: labelTextRect.size.width);
      textPainter.paint(context.canvas, labelTextRect.centerLeft - Offset(0, textPainter.height / 2));

      const valueTextMargin = kStrokeWidth;
      final valueTextRect = Offset(point.dx - kBarWidth / 2, point.dy - kLabelHeight - valueTextMargin) &
          Size(kBarWidth, kLabelHeight - valueTextMargin);
      final labelTextPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        textWidthBasis: TextWidthBasis.longestLine,
        text: TextSpan(
          text: Money(values[i].value).formatted,
          style: TextStyle(
            color: MkColors.primaryAccent.shade700,
            fontSize: 10,
            shadows: [ui.Shadow(blurRadius: 2, offset: const Offset(0, 1))],
            fontWeight: MkStyle.semibold,
          ),
        ),
      )..layout(maxWidth: valueTextRect.size.width);
      labelTextPainter.paint(context.canvas, valueTextRect.centerLeft - Offset(0, labelTextPainter.height / 2));
    }
  }
}

class GraphItemBar extends RenderBox {
  GraphItemBar({double value}) : _value = value;

  double _value;

  double get value => _value;

  set value(double value) {
    _value = value;
    markNeedsPaint();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      print(value);
    }
  }

  @override
  bool get sizedByParent => true;
}
