import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot/components//bottom_bar.dart';
import 'package:iot/components/icon_content.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot/components/daily_usage_progress.dart';

class HomePage extends StatelessWidget {
  static const String id = 'homePage';
  @override
  Widget build(BuildContext context) {
    // Replace these with actual usage data and user-set limit
    double dailyUsage = 150.0;
    double usageLimit = 200.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'IoT Dashboard',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
            Container(
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
              child: Container(
                width: 300.0,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/kilowot_h_display.png'),
                    Column(
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
              child: Container(
                width: 300.0,
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('images/money_display.png'),
                    Column(
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

            bottomBar(currentPageId: id),
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
