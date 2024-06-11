import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/daily_usage_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  double dailyUsage = 150.0; // This should be fetched from a database
  double usageLimit = 200.0; // This can be user-defined or fetched from a database
  double monthlyUsage = 0.0; // This should be fetched from a database
  double lastMonthBill = 1500.0; // This should be fetched from a database



  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchMonthlyUsage();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  void fetchMonthlyUsage() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');
    DatabaseEvent event = await databaseReference.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      DateTime now = DateTime.now();
      String currentMonth = DateFormat('yyyy-MM').format(now);

      double monthlyTotal = 0.0;
      data.forEach((key, value) {
        if (key.toString().startsWith(currentMonth)) {
          monthlyTotal += value.toDouble();
        }
      });

      setState(() {
        monthlyUsage = double.parse(monthlyTotal.toStringAsFixed(2));
      });
    } else {
      print('No hourly usage data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'IoT Dashboard',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Daily Usage Progress Bar
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 400.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DailyUsageProgress(
                    dailyUsage: dailyUsage,
                    initialUsageLimit: usageLimit,
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.red,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/kilowot_h_display.png', width: 50.0),
                    const SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$monthlyUsage kWh',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Electricity usage this month")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.red,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/money_display.png', width: 50.0),
                    const SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$lastMonthBill LKR',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Total electricity bill last month")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const bottomBar(currentPageId: HomePage.id),
          ],
        ),
      ),
    );
  }
}
