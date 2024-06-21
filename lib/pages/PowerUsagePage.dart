import 'package:flutter/material.dart';
import 'package:iot/pages/eBilPage.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:firebase_database/firebase_database.dart';
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
        title: const Text('Power Usage'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
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
          const SizedBox(height: 20.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, eBil.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                'Get E-bill',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
          const bottomBar(currentPageId: PowerUsagePage.id),
        ],
      ),
    );
  }
}

class PowerUsageView extends StatelessWidget {
  final String viewType;

  const PowerUsageView({super.key, required this.viewType});

  @override
  Widget build(BuildContext context) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('hourlyUsage');

    return FutureBuilder<DatabaseEvent>(
      future: databaseReference.once(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        DataSnapshot dataSnapshot = snapshot.data!.snapshot;
        if (!dataSnapshot.exists) {
          return const Center(child: Text('No data available'));
        }

        Map<dynamic, dynamic> usageData =
            dataSnapshot.value as Map<dynamic, dynamic>;

        List<_UsageData> chartData;
        if (viewType == 'Daily') {
          chartData = _getDailyData(usageData);
        } else if (viewType == 'Weekly') {
          chartData = _getWeeklyData(usageData);
        } else if (viewType == 'Monthly') {
          chartData = _getMonthlyData(usageData);
        } else {
          chartData = _getYearlyData(usageData);
        }

        for (var data in chartData) {
          print('Time: ${data.time}, Usage: ${data.usage}');
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            title: ChartTitle(text: 'Power Usage - $viewType'),
            trackballBehavior: TrackballBehavior(enable: true),
            tooltipBehavior: TooltipBehavior(
              enable: true,
            ),
            series: <CartesianSeries<_UsageData, String>>[
              AreaSeries<_UsageData, String>(
                dataSource: chartData,
                xValueMapper: (_UsageData data, _) => data.time,
                yValueMapper: (_UsageData data, _) => data.usage,
                name: 'Usage',
                borderColor: Colors.blueAccent,
                color: const Color.fromRGBO(146, 200, 244, 0.8745098039215686),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_UsageData> _getDailyData(Map<dynamic, dynamic> usageData) {
    List<_UsageData> dailyData = [];
    DateTime now = DateTime.now();
    DateFormat hourFormat = DateFormat('yyyy-MM-dd HH:mm');
    DateFormat displayHourFormat = DateFormat('h a');

    for (int i = 0; i <= now.hour; i++) {
      String hourKey =
          hourFormat.format(DateTime(now.year, now.month, now.day, i));
      String displayHour =
          displayHourFormat.format(DateTime(now.year, now.month, now.day, i));
      double usage =
          usageData.containsKey(hourKey) ? usageData[hourKey].toDouble() : 0.0;
      dailyData.add(_UsageData(displayHour, usage));
    }
    return dailyData;
  }

  List<_UsageData> _getWeeklyData(Map<dynamic, dynamic> usageData) {
    List<_UsageData> weeklyData = [];
    DateTime now = DateTime.now();
    DateFormat dayFormat = DateFormat('EEE');
    DateFormat dateKeyFormat = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < now.weekday; i++) {
      DateTime day = now.subtract(Duration(days: now.weekday - i - 1));
      String dayKey = dayFormat.format(day);
      String dateKey = dateKeyFormat.format(day);
      double usage = 0.0;

      for (int hour = 0; hour < 24; hour++) {
        String hourKey = '$dateKey ${hour.toString().padLeft(2, '0')}:00';
        if (usageData.containsKey(hourKey)) {
          usage += usageData[hourKey].toDouble();
        }
      }

      weeklyData.add(_UsageData(dayKey, usage));
    }

    return weeklyData;
  }

  List<_UsageData> _getMonthlyData(Map<dynamic, dynamic> usageData) {
    List<_UsageData> monthlyData = [];
    DateTime now = DateTime.now();
    DateFormat dayFormat = DateFormat('d');
    DateFormat dateKeyFormat = DateFormat('yyyy-MM-dd');

    for (int i = 1; i <= now.day; i++) {
      String dayKey = i.toString();
      String dateKey = dateKeyFormat.format(DateTime(now.year, now.month, i));
      double usage = 0.0;

      for (int hour = 0; hour < 24; hour++) {
        String hourKey = '$dateKey ${hour.toString().padLeft(2, '0')}:00';
        if (usageData.containsKey(hourKey)) {
          usage += usageData[hourKey].toDouble();
        }
      }

      monthlyData.add(_UsageData(dayKey, usage));
    }

    return monthlyData;
  }

  List<_UsageData> _getYearlyData(Map<dynamic, dynamic> usageData) {
    List<_UsageData> yearlyData = [];
    DateTime now = DateTime.now();
    DateFormat monthFormat = DateFormat('MMM');
    DateFormat dateKeyFormat = DateFormat('yyyy-MM-dd');

    for (int i = 1; i <= now.month; i++) {
      DateTime month = DateTime(now.year, i);
      String monthKey = monthFormat.format(month);
      double usage = 0.0;

      for (int day = 1;
          day <=
              (i == now.month
                  ? now.day
                  : DateUtils.getDaysInMonth(now.year, i));
          day++) {
        String dateKey = dateKeyFormat.format(DateTime(now.year, i, day));
        for (int hour = 0; hour < 24; hour++) {
          String hourKey = '$dateKey ${hour.toString().padLeft(2, '0')}:00';
          if (usageData.containsKey(hourKey)) {
            usage += usageData[hourKey].toDouble();
          }
        }
      }

      yearlyData.add(_UsageData(monthKey, usage));
    }

    return yearlyData;
  }
}

class _UsageData {
  _UsageData(this.time, this.usage);

  final String time;
  final double usage;
}
