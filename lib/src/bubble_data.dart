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
  })  : targetRadius = targetRadius ?? radius,
        startRadius = startRadius ?? radius,
        targetColor = targetColor ?? color,
        startColor = startColor ?? color;
}
