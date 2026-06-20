import 'package:flutter/widgets.dart';

class ScaleHelper {
  final BuildContext context;

  ScaleHelper(
    this.context,
  );

  double getVariableWidth(
    double width,
  ) {
    double size;

    size = width * MediaQuery.of(context).size.width / 360;

    return size;
  }

  double getVariableHeight(double height) {
    double size;
    size = height * MediaQuery.of(context).size.height / 712;

    return size;
  }

  double getVariableFontSize(double fontSize) {
    double size = fontSize * (MediaQuery.of(context).size.width / 960);
    return size;
  }

  bool get isPhone => MediaQuery.of(context).size.shortestSide < 550;

  getVariableWidthRelativeToViewPortionWidth(
      double width, double viewPortionWidth) {
    double size;

    size = width * MediaQuery.of(context).size.width / viewPortionWidth;

    return size;
  }
}
