import 'package:flutter/material.dart';
import 'bubble_data.dart';

class BubbleChartPainter extends CustomPainter {
  final List<BubbleData> bubbles;
  final bool showValues;
  final bool showBorder;
  final double borderWidth;
  final TextStyle? nameTextStyle;
  final TextStyle? valueTextStyle;
  final Widget? widget;

  BubbleChartPainter(this.bubbles,
      {this.showBorder = true,
      required this.showValues,
      this.borderWidth = 2.0,
      this.nameTextStyle,
      this.valueTextStyle,
      this.widget});

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
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

      final textPainter = TextPainter(
        text: TextSpan(
          children: [
            widget != null
                ? WidgetSpan(
                    child: widget!, alignment: PlaceholderAlignment.middle)
                : TextSpan(
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
      textPainter.paint(
        canvas,
        Offset(
          bubble.position.dx - textPainter.width / 2,
          bubble.position.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(BubbleChartPainter oldDelegate) => true;
}
