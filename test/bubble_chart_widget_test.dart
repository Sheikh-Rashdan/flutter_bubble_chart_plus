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

    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('custom-A-1.0'), findsOneWidget);
    expect(find.text('custom-B-2.0'), findsOneWidget);
  });

  testWidgets('clears the last bubble when names and values become empty',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _SingleBubbleHost()),
      ),
    );
    await tester.pump();

    BubbleChartPainter painter() => tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((widget) => widget.painter is BubbleChartPainter)
        .first
        .painter as BubbleChartPainter;

    expect(painter().bubbles, hasLength(1));

    tester
        .state<_SingleBubbleHostState>(find.byType(_SingleBubbleHost))
        .clear();
    await tester.pump();

    expect(painter().bubbles, hasLength(1));
    await tester.pump(const Duration(milliseconds: 400));

    expect(painter().bubbles, isEmpty);
  });

  testWidgets('new bubbles grow from zero', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _SingleBubbleHost()),
      ),
    );
    await tester.pump();

    tester
        .state<_SingleBubbleHostState>(find.byType(_SingleBubbleHost))
        .addBubble();
    await tester.pump();

    final painter = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((widget) => widget.painter is BubbleChartPainter)
        .first
        .painter as BubbleChartPainter;
    final newBubble =
        painter.bubbles.singleWhere((bubble) => bubble.name == 'B');

    expect(newBubble.radius, lessThan(_computeRadius(2, const [1, 2], 30, 55)));
  });

  testWidgets('value updates during size animation remain stable',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _RapidUpdateHost()),
      ),
    );
    await tester.pump();

    final host = tester.state<_RapidUpdateHostState>(
      find.byType(_RapidUpdateHost),
    );
    host.updateValues(const [1, 8, 10]);
    await tester.pump(const Duration(milliseconds: 75));
    host.updateValues(const [10, 1, 5]);
    await tester.pump(const Duration(milliseconds: 75));
    host.updateValues(const [3, 9, 1]);
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.text('custom-A'), findsOneWidget);
    expect(find.text('custom-B'), findsOneWidget);
    expect(find.text('custom-C'), findsOneWidget);
  });

  testWidgets('custom content remains stable when bubbles cross zero',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _ZeroRadiusContentHost()),
      ),
    );
    await tester.pump();

    final host = tester.state<_ZeroRadiusContentHostState>(
      find.byType(_ZeroRadiusContentHost),
    );
    host.clear();
    await tester.pump(const Duration(milliseconds: 50));
    host.restore();
    await tester.pump(const Duration(milliseconds: 50));
    host.clear();
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
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

class _SingleBubbleHost extends StatefulWidget {
  const _SingleBubbleHost();

  @override
  State<_SingleBubbleHost> createState() => _SingleBubbleHostState();
}

class _SingleBubbleHostState extends State<_SingleBubbleHost> {
  List<String> names = const ['A'];
  List<double> values = const [1];

  void addBubble() {
    setState(() {
      names = const ['A', 'B'];
      values = const [1, 2];
    });
  }

  void clear() {
    setState(() {
      names = const [];
      values = const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BubbleChart(names: names, values: values);
  }
}

class _RapidUpdateHost extends StatefulWidget {
  const _RapidUpdateHost();

  @override
  State<_RapidUpdateHost> createState() => _RapidUpdateHostState();
}

class _RapidUpdateHostState extends State<_RapidUpdateHost> {
  List<double> values = const [1, 4, 10];

  void updateValues(List<double> nextValues) {
    setState(() {
      values = nextValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BubbleChart(
      names: const ['A', 'B', 'C'],
      values: values,
      animationDuration: const Duration(milliseconds: 300),
      widgetBuilder: (name, value, color) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('custom-$name'),
          ...List.generate(8, (_) => const Text('detail')),
        ],
      ),
    );
  }
}

class _ZeroRadiusContentHost extends StatefulWidget {
  const _ZeroRadiusContentHost();

  @override
  State<_ZeroRadiusContentHost> createState() => _ZeroRadiusContentHostState();
}

class _ZeroRadiusContentHostState extends State<_ZeroRadiusContentHost> {
  List<String> names = const ['A'];
  List<double> values = const [1];

  void clear() {
    setState(() {
      names = const [];
      values = const [];
    });
  }

  void restore() {
    setState(() {
      names = const ['A'];
      values = const [1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BubbleChart(
      names: names,
      values: values,
      widgetBuilder: (name, value, color) => Text('custom-$name'),
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
