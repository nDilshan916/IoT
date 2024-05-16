import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DailyUsageProgress extends StatefulWidget {
  final double dailyUsage;
  final double initialUsageLimit;

  DailyUsageProgress(
      {required this.dailyUsage, required this.initialUsageLimit});

  @override
  _DailyUsageProgressState createState() => _DailyUsageProgressState();
}

class _DailyUsageProgressState extends State<DailyUsageProgress> {
  late double usageLimit;

  @override
  void initState() {
    super.initState();
    usageLimit = widget.initialUsageLimit;
    // _checkUsageAndNotify();
  }

  @override
  void didUpdateWidget(DailyUsageProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dailyUsage != oldWidget.dailyUsage) {
      // _checkUsageAndNotify();
    }
  }

  // void _checkUsageAndNotify() {
  //   double usagePercentage = widget.dailyUsage / usageLimit;
  //   if (usagePercentage >= 0.98) {
  //     NotificationService().showNotification(
  //       'Usage Alert',
  //       'Your daily power usage has reached 98% of the limit!',
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //change these things
    double barWidth = 0.2;
    double setRadius = 0.65;
    Color? secondColor = Colors.grey[350];
    // Calculate the percentage of the usage limit that has been used
    double usagePercentage = widget.dailyUsage / usageLimit;
    if (usagePercentage > 1) {
      usagePercentage = 1; // to ensure the percentage does not exceed 100%
    }

    return Card(
      margin: EdgeInsets.only( left: 8, right: 8),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 5000,
              title: GaugeTitle(
                text: 'Daily Power Usage',
                textStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                    )
                  ],
                ),
                RadialAxis(
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      axisValue: 50,
                      positionFactor: 0.05,
                      widget: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 75,
                      ),
                    ),
                    GaugeAnnotation(
                      axisValue: 50,
                      positionFactor: 0,
                      widget: Text(
                        '${(usagePercentage * 100).toStringAsFixed(1)}%', //change the decimal point here
                        style: TextStyle(
                            fontSize: 45.0, fontWeight: FontWeight.bold),
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
                )
              ],
            ),
          ),
          Slider(
            value: usageLimit,
            min: 100.0,
            max: 500.0,
            // divisions: 10,
            label: usageLimit.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                usageLimit = value;
              });
            },
          ),
          Text(
            'Set Daily Usage Limit',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
