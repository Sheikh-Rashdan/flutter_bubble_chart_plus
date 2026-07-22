import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bubble_chart_plus/flutter_bubble_chart_plus.dart';

void main() {
  testWidgets('bubble size animates smoothly between values', (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: _ChartHost())));
    await tester.pump();

    final initialPainter = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((widget) => widget.painter is BubbleChartPainter)
        .first
        .painter as BubbleChartPainter;
    final initialRadius = initialPainter.bubbles[1].radius;

    // ignore: invalid_use_of_protected_member
    tester.state<_ChartHostState>(find.byType(_ChartHost)).setState(() {
      tester.state<_ChartHostState>(find.byType(_ChartHost)).values = const [
        1,
        5,
        10
      ];
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final updatedPainter = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((widget) => widget.painter is BubbleChartPainter)
        .first
        .painter as BubbleChartPainter;
    final updatedRadius = updatedPainter.bubbles[1].radius;
    final targetRadius = _computeRadius(5, const [1, 5, 10], 30, 55);

    expect(updatedRadius, greaterThan(initialRadius));
    expect(updatedRadius, lessThanOrEqualTo(targetRadius));
  });

  testWidgets('widgetBuilder renders custom content for each bubble',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BubbleChart(
            names: const ['A', 'B'],
            values: const [1.0, 2.0],
            widgetBuilder: (name, value, color) => Text(
              'custom-$name-${value.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('custom-A-1.0'), findsOneWidget);
    expect(find.text('custom-B-2.0'), findsOneWidget);
  });
}

class _ChartHost extends StatefulWidget {
  const _ChartHost();

  @override
  State<_ChartHost> createState() => _ChartHostState();
}

class _ChartHostState extends State<_ChartHost> {
  List<double> values = const [1, 4, 10];

  @override
  Widget build(BuildContext context) {
    return BubbleChart(
      names: const ['A', 'B', 'C'],
      values: values,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeOut,
    );
  }
}

double _computeRadius(
    double value, List<double> values, double minRadius, double maxRadius) {
  final absValues = values.map((v) => v.abs()).toList();
  final maxAbsValue = absValues.reduce((a, b) => a > b ? a : b);
  final minAbsValue = absValues.reduce((a, b) => a < b ? a : b);

  if (maxAbsValue == minAbsValue) {
    return (minRadius + maxRadius) / 2;
  }

  final normalizedValue =
      (value.abs() - minAbsValue) / (maxAbsValue - minAbsValue);
  return minRadius + (normalizedValue * (maxRadius - minRadius));
}
