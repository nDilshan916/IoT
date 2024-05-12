import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot/WifiController.dart';
import 'package:iot/components//bottom_bar.dart';
import 'package:iot/components/icon_content.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  static const String id = 'homePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IoT Dashboard',
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(),
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
