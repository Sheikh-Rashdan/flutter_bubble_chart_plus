import 'package:flutter/material.dart';
import 'bubble_data.dart';

class BubbleChartPainter extends CustomPainter {
  final List<BubbleData> bubbles;
  final bool showValues;
  final bool showBorder;
  final double borderWidth;
  final TextStyle? nameTextStyle;
  final TextStyle? valueTextStyle;
  final bool hasWidgetBuilder;

  BubbleChartPainter(this.bubbles,
      {this.showBorder = true,
      required this.showValues,
      this.borderWidth = 2.0,
      this.nameTextStyle,
      this.valueTextStyle,
      this.hasWidgetBuilder = false});

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      if (bubble.radius <= 0) {
        continue;
      }

      final paint = Paint()
        ..color = bubble.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(bubble.position, bubble.radius, paint);

      if (showBorder) {
        final borderColor = bubble.value > 0
            ? bubble.color.withValues(alpha: 0.8)
            : bubble.color.withValues(alpha: 0.8);

        final borderPaint = Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;

        canvas.drawCircle(bubble.position, bubble.radius, borderPaint);
      }

      if (hasWidgetBuilder) {
        continue;
      }

      final textPainter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: bubble.name,
              style: nameTextStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (showValues)
              TextSpan(
                text:
                    '\n${bubble.value > 0 ? '+' : ''}${bubble.value.toStringAsFixed(1)}%',
                style: valueTextStyle ??
                    TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
              ),
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 3,
      );

      textPainter.layout(maxWidth: bubble.radius * 1.8);
      canvas.save();
      canvas.translate(bubble.position.dx, bubble.position.dy);
      canvas.scale(bubble.contentScale);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BubbleChartPainter oldDelegate) => true;
}
