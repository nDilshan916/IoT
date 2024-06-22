import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/daily_usage_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  double usageLimit = 0.0; // This can be user-defined or fetched from a database
  double monthlyUsage = 0.0; // This should be fetched from a database
  double lastMonthBill = 0.0; // This should be fetched from a database
  double reminderValue = 0.0;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    getCurrentUser();
    fetchUsageLimitFromDatabase();
    fetchDailyUsage();
    fetchMonthlyUsage();
    fetchLastMonthBill();
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

  void fetchUsageLimitFromDatabase() {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref('usageLimit');

    databaseReference.once().then((DatabaseEvent snapshot) {
      var limit = snapshot.snapshot.value;
      if (limit != null) {
        setState(() {
          usageLimit = (limit as num).toDouble();
        });
        print('USAGE LIMIT: $usageLimit');
      } else {
        setState(() {
          usageLimit = 200.0; // Default value if not found in database
        });
      }
    }).catchError((error) {
      print("Failed to fetch usage limit: $error");
      setState(() {
        usageLimit = 200.0; // Default value if error occurs
      });
    });
  }

  void fetchDailyUsage() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');

    // Use onValue listener for real-time updates
    databaseReference.onValue.listen((event) {
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
    }, onError: (error) {
      print("Failed to fetch daily usage: $error");
    });
  }

  void fetchMonthlyUsage() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');

    // Use onValue listener for real-time updates
    databaseReference.onValue.listen((event) {
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
    }, onError: (error) {
      print("Failed to fetch monthly usage: $error");
    });
  }


  void fetchLastMonthBill() async {
    final prefs = await SharedPreferences.getInstance();
    final double fixedCharge = prefs.getDouble('fixedCharge') ?? 0.0;
    final double rateX = prefs.getDouble('unitRateX') ?? 0.0;
    final double rateY = prefs.getDouble('unitRateY') ?? 0.0;
    final double rateZ = prefs.getDouble('unitRateZ') ?? 0.0;
    final double rateS = prefs.getDouble('unitRateS') ?? 0.0;

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('hourlyUsage');
    DatabaseEvent event = await databaseReference.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      DateTime now = DateTime.now();
      DateTime lastMonth = DateTime(now.year, now.month - 1);
      String lastMonthStr = DateFormat('yyyy-MM').format(lastMonth);

      double lastMonthTotal = 0.0;
      data.forEach((key, value) {
        if (key.toString().startsWith(lastMonthStr)) {
          lastMonthTotal += value.toDouble();
        }
      });

      double lastMonthUnits = lastMonthTotal / 1000.0;

      double lastMonthBillAmount = 0.0;
      if (lastMonthUnits > 93) {
        lastMonthBillAmount = 31 * rateX + 31 * rateY + 31 * rateZ + (lastMonthUnits - 93) * rateS + fixedCharge;
      } else if (lastMonthUnits > 62) {
        lastMonthBillAmount = 31 * rateX + 31 * rateY + (lastMonthUnits - 62) * rateZ + fixedCharge;
      } else if (lastMonthUnits > 31) {
        lastMonthBillAmount = 31 * rateX + (lastMonthUnits - 31) * rateY + fixedCharge;
      } else {
        lastMonthBillAmount = lastMonthUnits * rateX + fixedCharge;
      }

      setState(() {
        lastMonthBill = double.parse(lastMonthBillAmount.toStringAsFixed(2));
      });
      print('Last month usage: $lastMonthTotal');
      print('Bill: $lastMonthBill');
      print('z rate: $rateZ');
    } else {
      print('No hourly usage data available.');
    }
  }

  void fetchReminderValue() async{
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref('reminderValue');
    databaseReference.once().then((DatabaseEvent snapshot) { // Change DataSnapshot to DatabaseEvent
      final value = snapshot.snapshot.value; // Use snapshot.snapshot.value to access data
      if (value != null) {
        setState(() {
          reminderValue = (value as num).toDouble(); // Ensure the value is converted to double
        });
      }
    }).catchError((error) {
      print("Failed to load reminder value: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    print('current usage limit: $usageLimit');
    print('dailyUsage: $dailyUsage');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('IoT Dashboard'),
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
              text1: 'Rs.$lastMonthBill',
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
