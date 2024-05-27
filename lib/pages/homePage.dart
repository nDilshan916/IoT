import 'package:flutter/material.dart';
import 'package:iot/components//bottom_bar.dart';
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

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);

      }
    }
    catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Replace these with actual usage data and user-set limit
    double dailyUsage = 150.0;
    double usageLimit = 200.0;

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
            image: AssetImage(
                'images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Daily Usage Progress Bar
            SizedBox(
              height: 400.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DailyUsageProgress(
                  dailyUsage: dailyUsage,
                  initialUsageLimit: usageLimit,
                ),
              ),
            ),
            Card(
              color: Colors.red,
              child: SizedBox(
                width: 300.0,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/kilowot_h_display.png'),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                            '63.2 kWh',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text("Electricity usage this month")
                      ],
                    )
                  ],
                ),
              ),
            ),

            Card(
              color: Colors.red,
              child: SizedBox(
                width: 300.0,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/money_display.png'),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '1500 lkr',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text("Total electricity bill last month")
                      ],
                    )
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

// ElevatedButton(
//   onPressed: () async {
//     // Simulate toggling a device
//     await WifiController.toggleDevice('device123');
//   },
//   child: Text('Toggle Device via Wi-Fi'),
// ),

// Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Expanded(
//       child: Row(
//         children: [
//           Expanded(
//               child: ReusableCard(
//                 colour: Colors.black,
//                 onPress: (){},
//                 cardChild: IconContent(
//                   icon: FontAwesomeIcons.mars,
//                   lable: "MALE",
//                 ),
//               )
//           )
//         ],
//       ),
//     ),
//   ],
// ),
