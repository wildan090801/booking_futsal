import 'package:flutter/material.dart';

class ScrollBehaviorWithoutGlow extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
