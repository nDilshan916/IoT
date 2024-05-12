import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart'
    as charts; // Import charts_flutter package
import 'package:iot/pages/eBilPage.dart';
import 'package:iot/components/bottom_bar.dart';

class PowerUsagePage extends StatelessWidget {
  static const String id = 'PowerUsagePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Power Usage',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Placeholder for power usage chart
          Container(
            height: 300,
            padding: EdgeInsets.all(16.0),
            child: PowerUsageChart(), // Custom chart widget
          ),
          // Daily power usage
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Daily Power Usage: 150 kWh', // Replace with actual calculation
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          // Monthly power usage
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Monthly Power Usage: 4500 kWh', // Replace with actual calculation
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, eBil.id);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
              ),
              child: Text(
                'Get E-bil',
                style: TextStyle(
                  fontSize: 15.0
                ),
              ),
            ),
          ),
          bottomBar(currentPageId: id),
        ],
      ),
    );
  }
}

// Custom chart components to display power usage data
class PowerUsageChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final data = [
      PowerUsageData(DateTime(2024, 4, 20), 100),
      PowerUsageData(DateTime(2024, 4, 21), 150),
      PowerUsageData(DateTime(2024, 4, 22), 120),
      PowerUsageData(DateTime(2024, 4, 23), 130),
      PowerUsageData(DateTime(2024, 4, 24), 135),
      PowerUsageData(DateTime(2024, 4, 25), 130),
      PowerUsageData(DateTime(2024, 4, 26), 140),
      PowerUsageData(DateTime(2024, 5, 25), 160),
    ];

    // Create series for the chart
    final series = [
      charts.Series<PowerUsageData, DateTime>(
        id: 'PowerUsage',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PowerUsageData data, _) => data.date,
        measureFn: (PowerUsageData data, _) => data.usage,
        data: data,
      )
    ];

    // Create chart
    return charts.TimeSeriesChart(
      series,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

// Data model for power usage
class PowerUsageData {
  final DateTime date;
  final int usage;

  PowerUsageData(this.date, this.usage);
}
