import 'package:flutter/material.dart';

class BubbleData {
  String name;
  double value;
  Color color;
  Offset position;
  Offset velocity;
  double radius;
  double targetRadius;
  double startRadius;
  Color targetColor;
  Color startColor;
  double contentScale;

  BubbleData({
    required this.name,
    required this.value,
    required this.color,
    required this.position,
    required this.velocity,
    required this.radius,
    double? targetRadius,
    double? startRadius,
    Color? targetColor,
    Color? startColor,
    this.contentScale = 1.0,
  })  : targetRadius = targetRadius ?? radius,
        startRadius = startRadius ?? radius,
        targetColor = targetColor ?? color,
        startColor = startColor ?? color;
}
