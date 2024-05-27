import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PowerUsagePage extends StatefulWidget {
  static const String id = 'PowerUsagePage';

  const PowerUsagePage({super.key});

  @override
  _PowerUsagePageState createState() => _PowerUsagePageState();
}

class _PowerUsagePageState extends State<PowerUsagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('History'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'D'),
              Tab(text: 'W'),
              Tab(text: 'M'),
              Tab(text: 'Y'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                PowerUsageView(viewType: 'Daily'),
                PowerUsageView(viewType: 'Weekly'),
                PowerUsageView(viewType: 'Monthly'),
                PowerUsageView(viewType: 'Yearly'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PowerUsageView extends StatelessWidget {
  final String viewType;

  const PowerUsageView({required this.viewType, super.key});

  @override
  Widget build(BuildContext context) {
    List<PowerUsageData> data;

    final List<PowerUsageData> sampleData = [
      // Sample hourly data for Daily view
      PowerUsageData(DateTime(2024, 5, 21, 0), 10),
      PowerUsageData(DateTime(2024, 5, 21, 1), 20),
      PowerUsageData(DateTime(2024, 5, 21, 2), 15),
      PowerUsageData(DateTime(2024, 5, 21, 3), 25),
      PowerUsageData(DateTime(2024, 5, 21, 4), 30),
      PowerUsageData(DateTime(2024, 5, 21, 5), 20),
      PowerUsageData(DateTime(2024, 5, 21, 6), 35),
      PowerUsageData(DateTime(2024, 5, 21, 7), 40),
      PowerUsageData(DateTime(2024, 5, 21, 8), 45),
      PowerUsageData(DateTime(2024, 5, 21, 9), 50),
      PowerUsageData(DateTime(2024, 5, 21, 10), 60),
      PowerUsageData(DateTime(2024, 5, 21, 11), 55),
      PowerUsageData(DateTime(2024, 5, 21, 12), 50),
      PowerUsageData(DateTime(2024, 5, 21, 13), 45),
      PowerUsageData(DateTime(2024, 5, 21, 14), 35),
      PowerUsageData(DateTime(2024, 5, 21, 15), 30),
      PowerUsageData(DateTime(2024, 5, 21, 16), 25),
      PowerUsageData(DateTime(2024, 5, 21, 17), 20),
      PowerUsageData(DateTime(2024, 5, 21, 18), 15),
      PowerUsageData(DateTime(2024, 5, 21, 19), 10),
      PowerUsageData(DateTime(2024, 5, 21, 20), 5),
      PowerUsageData(DateTime(2024, 5, 21, 21), 10),
      PowerUsageData(DateTime(2024, 5, 21, 22), 20),
      PowerUsageData(DateTime(2024, 5, 21, 23), 15),

      // Sample data for Weekly view
      PowerUsageData(DateTime(2024, 5, 20), 200),
      PowerUsageData(DateTime(2024, 5, 19), 150),
      PowerUsageData(DateTime(2024, 5, 18), 180),
      PowerUsageData(DateTime(2024, 5, 17), 170),
      PowerUsageData(DateTime(2024, 5, 16), 160),
      PowerUsageData(DateTime(2024, 5, 15), 140),
      PowerUsageData(DateTime(2024, 5, 14), 130),

      // Sample data for Monthly view
      PowerUsageData(DateTime(2024, 5, 1), 100),
      PowerUsageData(DateTime(2024, 4, 1), 200),
      PowerUsageData(DateTime(2024, 3, 1), 300),
      PowerUsageData(DateTime(2024, 2, 1), 400),
      PowerUsageData(DateTime(2024, 1, 1), 500),

      // Sample data for Yearly view
      PowerUsageData(DateTime(2023, 1, 1), 1000),
      PowerUsageData(DateTime(2022, 1, 1), 1500),
      PowerUsageData(DateTime(2021, 1, 1), 2000),
    ];

    // Filter and aggregate data based on the selected view type
    switch (viewType) {
      case 'Daily':
        data = sampleData.where((d) => d.date.day == 21 && d.date.month == 5 && d.date.year == 2024).toList();
        break;
      case 'Weekly':
        data = _aggregateDataByWeek(sampleData);
        break;
      case 'Monthly':
        data = _aggregateDataByMonth(sampleData);
        break;
      case 'Yearly':
        data = _aggregateDataByYear(sampleData);
        break;
      default:
        data = sampleData;
    }

    late String totalUsage = 'Total: ${data.map((e) => e.usage).reduce((a, b) => a + b)} kWh';
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SfCartesianChart(
              margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
              trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: const InteractiveTooltip(
                  format: 'point.x : point.y',
                ),
              ),
              primaryXAxis: _buildPrimaryXAxis(viewType),
              primaryYAxis: _buildPrimaryYAxis(),
              series: <LineSeries<PowerUsageData, DateTime>>[
                LineSeries<PowerUsageData, DateTime>(
                  dataSource: data,
                  xValueMapper: (PowerUsageData data, _) => data.date,
                  yValueMapper: (PowerUsageData data, _) => data.usage,
                ),
              ],
            ),
            Text(
              totalUsage,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the primary X axis based on the view type
  ChartAxis _buildPrimaryXAxis(String viewType) {
    switch (viewType) {
      case 'Daily':
        return DateTimeAxis(
          intervalType: DateTimeIntervalType.hours,
          dateFormat: DateFormat.Hm(),
        );
      case 'Weekly':
        return DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
          dateFormat: DateFormat.MMMd(),
        );
      case 'Monthly':
        return DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
          dateFormat: DateFormat.d(),
        );
      case 'Yearly':
        return DateTimeAxis(
          intervalType: DateTimeIntervalType.months,
          dateFormat: DateFormat.yMMM(),
        );
      default:
        return const DateTimeAxis();
    }
  }

  /// Builds the primary Y axis
  NumericAxis _buildPrimaryYAxis() {
    return const NumericAxis(
      title: AxisTitle(text: 'Usage'),
      interval: 50,
    );
  }

  List<PowerUsageData> _aggregateDataByWeek(List<PowerUsageData> data) {
    final Map<int, int> weeklyUsage = {};
    for (var datum in data) {
      final weekOfYear = datum.date.weekOfYear;
      weeklyUsage[weekOfYear] = (weeklyUsage[weekOfYear] ?? 0) + datum.usage;
    }
    return weeklyUsage.entries.map((entry) => PowerUsageData(DateTime(2024).add(Duration(days: entry.key * 7)), entry.value)).toList();
  }

  List<PowerUsageData> _aggregateDataByMonth(List<PowerUsageData> data) {
    final Map<int, int> monthlyUsage = {};
    for (var datum in data) {
      final monthOfYear = datum.date.month;
      monthlyUsage[monthOfYear] = (monthlyUsage[monthOfYear] ?? 0) + datum.usage;
    }
    return monthlyUsage.entries.map((entry) => PowerUsageData(DateTime(2024, entry.key), entry.value)).toList();
  }

  List<PowerUsageData> _aggregateDataByYear(List<PowerUsageData> data) {
    final Map<int, int> yearlyUsage = {};
    for (var datum in data) {
      final year = datum.date.year;
      yearlyUsage[year] = (yearlyUsage[year] ?? 0) + datum.usage;
    }
    return yearlyUsage.entries.map((entry) => PowerUsageData(DateTime(entry.key), entry.value)).toList();
  }
}

class PowerUsageData {
  final DateTime date;
  final int usage;

  PowerUsageData(this.date, this.usage);
}

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysDifference = difference(firstDayOfYear).inDays;
    return (daysDifference / 7).ceil();
  }
}
