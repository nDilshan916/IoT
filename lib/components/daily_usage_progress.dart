import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DailyUsageProgress extends StatefulWidget {
  final double dailyUsage;
  final double initialUsageLimit;

  const DailyUsageProgress(
      {super.key, required this.dailyUsage, required this.initialUsageLimit});

  @override
  _DailyUsageProgressState createState() => _DailyUsageProgressState();
}

class _DailyUsageProgressState extends State<DailyUsageProgress> {
  late double usageLimit;

  @override
  void initState() {
    super.initState();
    usageLimit = widget.initialUsageLimit;
  }

  @override
  void didUpdateWidget(DailyUsageProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dailyUsage != oldWidget.dailyUsage) {
      // Update usage and notify if needed
    }
  }

  void _updateUsageLimit(double newLimit) {
    setState(() {
      usageLimit = newLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = 0.20;
    double setRadius = 0.65;
    double usageWattLimit = usageLimit * 1000;
    double dailyUsage = widget.dailyUsage;
    Color? secondColor = Colors.grey[350];
    double usagePercentage = dailyUsage / usageWattLimit;
    if (usagePercentage > 1) {
      usagePercentage = 1;
    }

    print('usage precentage: $usagePercentage');
    print('usage watt limit: $usageWattLimit');
    print('wdt dailyUsage: $dailyUsage');

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 5000,
              title: const GaugeTitle(
                text: 'Daily Power Usage',
                textStyle: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              axes: <RadialAxis>[
                RadialAxis(
                  startAngle: 270,
                  endAngle: 270,
                  radiusFactor: setRadius,
                  minimum: 0,
                  interval: 1,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: barWidth,
                    cornerStyle: CornerStyle.bothFlat,
                    color: secondColor,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: usagePercentage * 100,
                      width: barWidth,
                      pointerOffset: 0.0015,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: usagePercentage > 0.8
                          ? Colors.red
                          : (usagePercentage > 0.5
                          ? Colors.orange
                          : Colors.green),
                    ),
                  ],
                ),
                RadialAxis(
                  annotations: <GaugeAnnotation>[
                    const GaugeAnnotation(
                      axisValue: 50,
                      positionFactor: 0.05,
                      widget: CircleAvatar(
                        backgroundColor: Colors.red,
                        // radius: 70,
                        maxRadius: 70,
                      ),
                    ),
                    GaugeAnnotation(
                      axisValue: 50,
                      positionFactor: 0,
                      widget: Text(
                        '${(usagePercentage * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  minimum: 0,
                  interval: 1,
                  maximum: 90,
                  showLabels: false,
                  showTicks: true,
                  showAxisLine: false,
                  tickOffset: 0,
                  offsetUnit: GaugeSizeUnit.factor,
                  minorTicksPerInterval: 0,
                  startAngle: 270,
                  endAngle: 270,
                  radiusFactor: setRadius,
                  majorTickStyle: MajorTickStyle(
                    length: barWidth,
                    thickness: 3,
                    lengthUnit: GaugeSizeUnit.factor,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

