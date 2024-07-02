import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math';

class DailyUsageProgress extends StatefulWidget {
  final double dailyUsage;
  final double initialUsageLimit;

  DailyUsageProgress({
    super.key,
    required this.dailyUsage,
    required this.initialUsageLimit,
  });

  @override
  _DailyUsageProgressState createState() => _DailyUsageProgressState();
}

class _DailyUsageProgressState extends State<DailyUsageProgress>
    with SingleTickerProviderStateMixin {
  late double usageLimit;
  late double dailyUsage;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    usageLimit = widget.initialUsageLimit;
    dailyUsage = widget.dailyUsage;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 13),
    )..repeat(reverse: false);
  }

  @override
  void didUpdateWidget(DailyUsageProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialUsageLimit != oldWidget.initialUsageLimit) {
      setState(() {
        usageLimit = widget.initialUsageLimit;
      });
    }
    if (widget.dailyUsage != oldWidget.dailyUsage) {
      setState(() {
        dailyUsage = widget.dailyUsage;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = 0.20;
    double setRadius = 0.65;
    double innerCircleRadius = 75.0;
    double usageWattLimit = usageLimit;
    int dUsage = dailyUsage.round();
    Color? secondColor = Colors.grey[350];
    double usagePercentage = usageWattLimit > 0 ? dailyUsage / usageWattLimit : 0;
    if (usagePercentage > 1) {
      usagePercentage = 1;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SfRadialGauge(
            enableLoadingAnimation: true,
            animationDuration: 7000,
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
                  GaugeAnnotation(
                    axisValue: 50,
                    positionFactor: 0.05,
                    widget: ClipPath(
                      clipper: CircleClipper(),
                      child: CustomPaint(
                        size: Size(innerCircleRadius * 2, innerCircleRadius * 2),
                        painter: FluidCirclePainter(
                          animation: _controller,
                          usagePercentage: usagePercentage,
                          color: usagePercentage > 0.8
                              ? Colors.red[400]!
                              : (usagePercentage > 0.5
                              ? Colors.orange[400]!
                              : Colors.green[400]!),
                        ),
                      ),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Today Usage: $dUsage UNITS (kWh)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class FluidCirclePainter extends CustomPainter {
  final Animation<double> animation;
  final double usagePercentage;
  final Color color;

  FluidCirclePainter({
    required this.animation,
    required this.usagePercentage,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    double waveHeight = 7.0;
    double progressHeight = size.height * (1 - usagePercentage);

    path.moveTo(0, progressHeight);

    for (double i = 0; i <= size.width; i++) {
      double y = progressHeight + waveHeight * sin((i / size.width * 2 * pi) + (animation.value * 2 * pi));
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Clip the path to a circular shape
    canvas.save();
    canvas.clipPath(Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      )));
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
