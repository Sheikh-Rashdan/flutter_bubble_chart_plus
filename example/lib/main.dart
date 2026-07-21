import 'package:flutter/material.dart';
import 'package:flutter_bubble_chart_plus/flutter_bubble_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const BubbleChartDemo(),
    );
  }
}

class BubbleChartDemo extends StatefulWidget {
  const BubbleChartDemo({super.key});

  @override
  State<BubbleChartDemo> createState() => _BubbleChartDemoState();
}

class _BubbleChartDemoState extends State<BubbleChartDemo> {
  List<String> names = [
    'BTC',
    'ETH',
    'BNB',
    'SOL',
    'XRP',
    'ADA',
    'DOGE',
    'AVAX',
    'DOT',
    'MATIC',
  ];

  List<double> values = [
    5.2,
    -3.8,
    2.1,
    8.5,
    -1.2,
    4.3,
    -6.7,
    3.9,
    -2.4,
    7.1,
  ];

  void _regenerateData() {
    setState(() {
      values = List.generate(
        names.length,
        (index) =>
            (DateTime.now().millisecondsSinceEpoch % 1000 / 50.0) -
            10.0 +
            (index * 2.5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Chart Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _regenerateData,
            tooltip: 'Regenerate Data',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Market Heat Map',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap bubbles to interact, tap empty space to push bubbles away',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BubbleChart(
                    names: names,
                    values: values,
                    onBubbleTap: (name) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on $name'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    minRadius: 35.0,
                    maxRadius: 60.0,
                    minOpacity: 0.3,
                    maxOpacity: 0.7,
                    showBorder: true,
                    borderWidth: 2.5,
                    damping: 0.98,
                    minVelocity: 0.3,
                    collisionDamping: 0.7,
                    randomForce: 0.05,
                    repulsionForce: 15.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.green, 'Positive'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.red, 'Negative'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
