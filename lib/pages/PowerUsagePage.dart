import 'package:flutter/material.dart';
import 'package:iot/pages/eBilPage.dart';
import 'package:iot/components/bottom_bar.dart';

import '../components/charts.dart';

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
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, eBil.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text(
              'Get E-bill',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          const bottomBar(currentPageId: PowerUsagePage.id),
        ],
      ),
    );
  }
}

