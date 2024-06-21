import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/daily_usage_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iot/pages/settingPages/setLimit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  double dailyUsage = 0.0; // This should be fetched from a database
  late double usageLimit; // This can be user-defined or fetched from a database
  double monthlyUsage = 0.0; // This should be fetched from a database
  double lastMonthBill = 1500.0; // This should be fetched from a database
  double reminderValue = 0.0;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    getCurrentUser();
    fetchUsageLimit();
    fetchDailyUsage();
    fetchMonthlyUsage();
    fetchReminderValue();
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
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

  void fetchUsageLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usageLimit = prefs.getDouble('usageLimit') ?? 200.0; // Default value
    });
  }

  void fetchDailyUsage() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');
    DatabaseEvent event = await databaseReference.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      DateTime now = DateTime.now();
      String currentDay = DateFormat('yyyy-MM-dd').format(now);

      double dailyTotal = 0.0;
      data.forEach((key, value) {
        if (key.toString().startsWith(currentDay)) {
          dailyTotal += value.toDouble();
        }
      });

      setState(() {
        dailyUsage = double.parse(dailyTotal.toStringAsFixed(2));
      });

      // Check if daily usage exceeds reminder value
      // checkReminder(dailyTotal);

    } else {
      print('No hourly usage data available.');
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

  void _navigateAndSetLimit() async {
    final newLimit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetLimit(currentLimit: usageLimit),
      ),
    );
    if (newLimit != null) {
      setState(() {
        usageLimit = newLimit;
      });
    }
  }
  void fetchReminderValue() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reminderValue = prefs.getDouble('reminderValue') ?? 0.00;
    });
  }

  // void checkReminder(double usage) {
  //   if (reminderValue > 0 && usage >= (reminderValue / 100) * usageLimit) {
  //     NotificationService().showNotification(
  //       0,
  //       'Usage Reminder',
  //       'You have reached ${reminderValue.toStringAsFixed(0)}% of your daily usage limit.',
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('current usage limit: $usageLimit');
    print('dailyUsage: $dailyUsage');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('IoT Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateAndSetLimit,
          ),
        ],
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DailyUsageProgress(
                  dailyUsage: dailyUsage,
                  initialUsageLimit: usageLimit,
                ),
              ),
            ),
            InfoCard(
              img: Image.asset('images/kilowot_h_display.png', width: 50.0),
              text1: '$monthlyUsage kWh',
              text2: "Electricity usage this month",
            ),
            InfoCard(
              img: Image.asset('images/money_display.png', width: 50.0),
              text1: '$lastMonthBill LKR',
              text2: "Total electricity bill last month",
            ),
            const bottomBar(currentPageId: HomePage.id),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.img,
    required this.text1,
    required this.text2,
  });

  final Image img;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: Colors.red,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            img,
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  text2,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
