import 'dart:math' as math;

import 'package:flutter/widgets.dart';

// https://math.stackexchange.com/questions/377169/going-from-a-value-inside-1-1-to-a-value-in-another-range/377174#377174
double interpolate({
  double input,
  double inputMin = 0,
  double inputMax = 1,
  double outputMin = 0,
  double outputMax = 1,
  Curve curve = Curves.linear,
}) {
  double result = math.max(inputMin, input);

  if (outputMin == outputMax) {
    return outputMin;
  }

  if (inputMin == inputMax) {
    if (input <= inputMin) {
      return outputMin;
    }
    return outputMax;
  }

  // Input Range
  if (inputMin == -double.infinity) {
    result = -result;
  } else if (inputMax == double.infinity) {
    result = result - inputMin;
  } else {
    result = (result - inputMin) / (inputMax - inputMin);
  }

  // Easing
  result = curve.transform(result);

  // Output Range
  if (outputMin == -double.infinity) {
    result = -result;
  } else if (outputMax == double.infinity) {
    result = result + outputMin;
  } else {
    result = result * (outputMax - outputMin) + outputMin;
  }

  return result;
}
