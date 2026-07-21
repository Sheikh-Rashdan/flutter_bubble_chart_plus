# Bubble Chart

[![pub package](https://img.shields.io/pub/v/flutter_bubble_chart.svg)](https://pub.dev/packages/flutter_bubble_chart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful and interactive bubble chart widget for Flutter with physics-based animations. Perfect for visualizing market data, statistics, and dynamic datasets.

## Features

✨ **Physics-Based Animation** - Smooth, realistic bubble movements with collision detection  
🎨 **Highly Customizable** - Control colors, sizes, opacity, borders, and text styles  
👆 **Interactive** - Tap bubbles to trigger callbacks, tap empty space to push bubbles away  
📊 **Data Visualization** - Perfect for market heat maps, statistics, and dynamic data  
⚡ **Performance Optimized** - Efficient rendering with CustomPainter  
🎯 **Easy to Use** - Simple API with sensible defaults

## Demo

<p align="center">
  <img src="https://raw.githubusercontent.com/zengchao928/bubble_chart/main/screenshots/demo.png" alt="Bubble Chart Demo" width="300"/>
</p>

<p align="center">
  <video src="https://github.com/user-attachments/assets/demo.mp4" width="300" controls>
    Your browser does not support the video tag.
  </video>
</p>

*Interactive bubble chart with physics-based animations - tap bubbles to interact, tap empty space to push them away!*

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_bubble_chart_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter_bubble_chart/flutter_bubble_chart.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: BubbleChart(
        names: ['BTC', 'ETH', 'BNB', 'SOL', 'XRP'],
        values: [5.2, -3.8, 2.1, 8.5, -1.2],
        onBubbleTap: (name) {
          print('Tapped on $name');
        },
      ),
    );
  }
}
```

### Advanced Example

```dart
BubbleChart(
  names: ['BTC', 'ETH', 'BNB', 'SOL', 'XRP'],
  values: [5.2, -3.8, 2.1, 8.5, -1.2],
  onBubbleTap: (name) {
    print('Tapped on $name');
  },
  // Customize colors
  positiveColor: Colors.green.withOpacity(0.5),
  negativeColor: Colors.red.withOpacity(0.5),
  
  // Customize bubble sizes
  minRadius: 35.0,
  maxRadius: 60.0,
  
  // Customize opacity range
  minOpacity: 0.3,
  maxOpacity: 0.7,
  
  // Customize border
  showBorder: true,
  borderWidth: 2.5,
  
  // Customize text styles
  nameTextStyle: TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  valueTextStyle: TextStyle(
    color: Colors.white70,
    fontSize: 14,
  ),
  
  // Customize physics
  damping: 0.98,
  minVelocity: 0.3,
  collisionDamping: 0.7,
  randomForce: 0.05,
  repulsionForce: 15.0,
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `names` | `List<String>` | **required** | Names displayed on bubbles |
| `values` | `List<double>` | **required** | Values determining bubble size |
| `colors` | `List<Color>` | `null` | Values determining bubble color |
| `showValues` | `bool` | `false` | Whether to display values |
| `onBubbleTap` | `Function(String)?` | `null` | Callback when a bubble is tapped |
| `positiveColor` | `Color?` | `Colors.green` | Color for positive values |
| `negativeColor` | `Color?` | `Colors.red` | Color for negative values |
| `minRadius` | `double` | `30.0` | Minimum bubble radius |
| `maxRadius` | `double` | `55.0` | Maximum bubble radius |
| `minOpacity` | `double` | `0.25` | Minimum bubble opacity |
| `maxOpacity` | `double` | `0.6` | Maximum bubble opacity |
| `showBorder` | `bool` | `true` | Whether to show bubble borders |
| `borderWidth` | `double` | `2.0` | Width of bubble borders |
| `nameTextStyle` | `TextStyle?` | `null` | Style for bubble names |
| `valueTextStyle` | `TextStyle?` | `null` | Style for bubble values |
| `damping` | `double` | `0.98` | Velocity damping factor (0-1) |
| `minVelocity` | `double` | `0.3` | Minimum velocity threshold |
| `collisionDamping` | `double` | `0.7` | Energy loss on collision (0-1) |
| `randomForce` | `double` | `0.05` | Random force applied to bubbles |
| `repulsionForce` | `double` | `15.0` | Force when tapping empty space |

## How It Works

The bubble chart uses physics-based animations to create realistic bubble movements:

1. **Collision Detection** - Bubbles detect and respond to collisions with each other and boundaries
2. **Velocity Damping** - Bubbles gradually slow down for natural movement
3. **Random Forces** - Small random forces keep bubbles in motion
4. **Repulsion** - Tapping empty space pushes nearby bubbles away
5. **Size Mapping** - Bubble sizes are automatically scaled based on value magnitudes

## Use Cases

- 📈 **Market Heat Maps** - Visualize cryptocurrency or stock market changes
- 📊 **Statistics Dashboard** - Display dynamic statistical data
- 🎮 **Game Leaderboards** - Show player scores in an engaging way
- 📉 **Financial Data** - Represent portfolio performance
- 🌡️ **Sensor Data** - Visualize real-time sensor readings

## Example App

Check out the [example](example/) directory for a complete working example.

To run the example:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created with ❤️ by zengchao

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Support

If you like this package, please give it a ⭐ on [GitHub](https://github.com/zengchao928/bubble_chart)!

For issues and feature requests, please file them on the [issue tracker](https://github.com/zengchao928/bubble_chart/issues).
