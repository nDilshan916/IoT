//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:iot/pages/PowerUsagePage.dart';
// import 'package:iot/pages/homePage.dart';
// import 'package:iot/pages/settingPage.dart';
// import 'package:iot/pages/switchPage.dart';
//
// class bottomBar extends StatelessWidget {
//   double iconSize = 34.0;
//
//   Color iconColor = Colors.grey;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 46.0,
//       color: Color(0xFF0A0E21),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, HomePage.id);
//             },
//             child: Image.asset('images/home icon.png'),
//
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, SwitchPage.id);
//             },
//             child: Image.asset('images/switch icon.png'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, PowerUsagePage.id);
//             },
//
//             child: Image.asset('images/statics icon.png'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, SettingPage.id);
//             },
//             child: Image.asset('images/settings.png')
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iot/pages/PowerUsagePage.dart';
import 'package:iot/pages/homePage.dart';
import 'package:iot/pages/settingPage.dart';
import 'package:iot/pages/switchPage.dart';

class bottomBar extends StatelessWidget {
  final String currentPageId;

  const bottomBar({super.key, required this.currentPageId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.0,
      color: const Color(0xFF0A0E21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTextButton(context, 'images/home icon.png', HomePage.id),
          buildTextButton(context, 'images/switch icon.png', SwitchPage.id),
          buildTextButton(context, 'images/statics icon.png', PowerUsagePage.id),
          buildTextButton(context, 'images/settings.png', SettingPage.id),
        ],
      ),
    );
  }

  Widget buildTextButton(BuildContext context, String imagePath, String routeName) {
    bool isSelected = currentPageId == routeName;
    return TextButton(
      onPressed: () {
        if (!isSelected) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Image.asset(
        imagePath,
        width: 24,
        height: 24,
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }
}
