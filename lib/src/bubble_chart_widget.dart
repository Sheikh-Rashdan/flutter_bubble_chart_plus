import 'package:flutter/material.dart';
import 'dart:math';
import 'bubble_data.dart';
import 'bubble_chart_painter.dart';

class BubbleChart extends StatefulWidget {
  final List<String> names;
  final List<double> values;
  final List<Color> colors;
  final bool showValues;
  final Function(String)? onBubbleTap;
  final Color? positiveColor;
  final Color? negativeColor;
  final double minRadius;
  final double maxRadius;
  final double minOpacity;
  final double maxOpacity;
  final bool showBorder;
  final double borderWidth;
  final TextStyle? nameTextStyle;
  final TextStyle? valueTextStyle;
  final double damping;
  final double minVelocity;
  final double collisionDamping;
  final double randomForce;
  final double repulsionForce;

  const BubbleChart({
    super.key,
    required this.names,
    required this.values,
    required this.colors,
    required this.showValues,
    this.onBubbleTap,
    this.positiveColor,
    this.negativeColor,
    this.minRadius = 30.0,
    this.maxRadius = 55.0,
    this.minOpacity = 0.25,
    this.maxOpacity = 0.6,
    this.showBorder = true,
    this.borderWidth = 2.0,
    this.nameTextStyle,
    this.valueTextStyle,
    this.damping = 0.98,
    this.minVelocity = 0.3,
    this.collisionDamping = 0.7,
    this.randomForce = 0.05,
    this.repulsionForce = 15.0,
  });

  @override
  State<BubbleChart> createState() => _BubbleChartState();
}

class _BubbleChartState extends State<BubbleChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<BubbleData> bubbles = [];
  final Random random = Random();
  Size? screenSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
        _updateBubbles();
      });
    _controller.repeat();
  }

  @override
  void didUpdateWidget(BubbleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.names != widget.names || oldWidget.values != widget.values) {
      if (screenSize != null) {
        _generateBubbles(screenSize!);
      }
    }
  }

  void _generateBubbles(Size size) {
    if (widget.names.isEmpty || widget.values.isEmpty) return;

    bubbles.clear();

    final absValues = widget.values.map((v) => v.abs()).toList();
    final maxAbsValue = absValues.reduce((a, b) => a > b ? a : b);
    final minAbsValue = absValues.reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < widget.names.length && i < widget.values.length; i++) {
      final name = widget.names[i];
      final value = widget.values[i];
      final absValue = value.abs();

      double radius;
      if (maxAbsValue == minAbsValue) {
        radius = (widget.minRadius + widget.maxRadius) / 2;
      } else {
        final normalizedValue =
            (absValue - minAbsValue) / (maxAbsValue - minAbsValue);
        radius = widget.minRadius +
            (normalizedValue * (widget.maxRadius - widget.minRadius));
      }

      final opacity = widget.minOpacity +
          (absValue / maxAbsValue * (widget.maxOpacity - widget.minOpacity))
              .clamp(0.0, widget.maxOpacity);

      final positiveColor =
          widget.positiveColor ?? Colors.green.withValues(alpha: opacity);
      final negativeColor =
          widget.negativeColor ?? Colors.red.withValues(alpha: opacity);

      final color = value > 0 ? positiveColor : negativeColor;

      final x = radius + random.nextDouble() * (size.width - radius * 2);
      final y = radius + random.nextDouble() * (size.height - radius * 2);

      bubbles.add(BubbleData(
        name: name,
        value: value,
        color: color,
        position: Offset(x, y),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 2.0,
          (random.nextDouble() - 0.5) * 2.0,
        ),
        radius: radius,
      ));
    }
  }

  void _handleTap(Offset tapPosition) {
    for (var bubble in bubbles) {
      final dx = bubble.position.dx - tapPosition.dx;
      final dy = bubble.position.dy - tapPosition.dy;
      final distance = sqrt(dx * dx + dy * dy);

      if (distance < bubble.radius) {
        if (widget.onBubbleTap != null) {
          widget.onBubbleTap!(bubble.name);
        }
        return;
      }

      if (distance > 0) {
        final force = widget.repulsionForce / (distance * 0.01 + 1);
        final angle = atan2(dy, dx);

        bubble.velocity += Offset(
          cos(angle) * force,
          sin(angle) * force,
        );
      }
    }
  }

  void _updateBubbles() {
    if (screenSize == null || bubbles.isEmpty) return;

    setState(() {
      for (var bubble in bubbles) {
        bubble.velocity += Offset(
          (random.nextDouble() - 0.5) * widget.randomForce,
          (random.nextDouble() - 0.5) * widget.randomForce,
        );

        bubble.velocity = bubble.velocity * widget.damping;

        final speed = sqrt(bubble.velocity.dx * bubble.velocity.dx +
            bubble.velocity.dy * bubble.velocity.dy);
        if (speed > 0 && speed < widget.minVelocity) {
          final scale = widget.minVelocity / speed;
          bubble.velocity = bubble.velocity * scale;
        }

        bubble.position += bubble.velocity;

        if (bubble.position.dx - bubble.radius < 0) {
          bubble.velocity = Offset(
              -bubble.velocity.dx * widget.collisionDamping,
              bubble.velocity.dy);
          bubble.position = Offset(bubble.radius, bubble.position.dy);
        } else if (bubble.position.dx + bubble.radius > screenSize!.width) {
          bubble.velocity = Offset(
              -bubble.velocity.dx * widget.collisionDamping,
              bubble.velocity.dy);
          bubble.position =
              Offset(screenSize!.width - bubble.radius, bubble.position.dy);
        }

        if (bubble.position.dy - bubble.radius < 0) {
          bubble.velocity = Offset(bubble.velocity.dx,
              -bubble.velocity.dy * widget.collisionDamping);
          bubble.position = Offset(bubble.position.dx, bubble.radius);
        } else if (bubble.position.dy + bubble.radius > screenSize!.height) {
          bubble.velocity = Offset(bubble.velocity.dx,
              -bubble.velocity.dy * widget.collisionDamping);
          bubble.position =
              Offset(bubble.position.dx, screenSize!.height - bubble.radius);
        }
      }

      for (int i = 0; i < bubbles.length; i++) {
        for (int j = i + 1; j < bubbles.length; j++) {
          final bubble1 = bubbles[i];
          final bubble2 = bubbles[j];

          final dx = bubble2.position.dx - bubble1.position.dx;
          final dy = bubble2.position.dy - bubble1.position.dy;
          final distance = sqrt(dx * dx + dy * dy);
          final minDistance = bubble1.radius + bubble2.radius;

          if (distance < minDistance && distance > 0) {
            final angle = atan2(dy, dx);

            final overlap = minDistance - distance;
            final separationX = cos(angle) * overlap * 0.5;
            final separationY = sin(angle) * overlap * 0.5;

            bubble1.position -= Offset(separationX, separationY);
            bubble2.position += Offset(separationX, separationY);

            final relativeVelocityX = bubble1.velocity.dx - bubble2.velocity.dx;
            final relativeVelocityY = bubble1.velocity.dy - bubble2.velocity.dy;

            final velocityAlongCollision =
                relativeVelocityX * cos(angle) + relativeVelocityY * sin(angle);

            if (velocityAlongCollision > 0) {
              final impulse = velocityAlongCollision * widget.collisionDamping;

              bubble1.velocity -= Offset(
                impulse * cos(angle) * 0.5,
                impulse * sin(angle) * 0.5,
              );
              bubble2.velocity += Offset(
                impulse * cos(angle) * 0.5,
                impulse * sin(angle) * 0.5,
              );
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (screenSize == null ||
            screenSize!.width != constraints.maxWidth ||
            screenSize!.height != constraints.maxHeight) {
          screenSize = Size(constraints.maxWidth, constraints.maxHeight);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _generateBubbles(screenSize!);
          });
        }

        return GestureDetector(
          onTapDown: (details) {
            _handleTap(details.localPosition);
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: BubbleChartPainter(
              bubbles,
              showBorder: widget.showBorder,
              borderWidth: widget.borderWidth,
              nameTextStyle: widget.nameTextStyle,
              valueTextStyle: widget.valueTextStyle,
            ),
          ),
        );
      },
    );
  }
}
