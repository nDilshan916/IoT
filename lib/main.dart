import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot/pages/PowerUsagePage.dart';
import 'package:iot/pages/homePage.dart';
import 'package:iot/pages/switchPage.dart';
import 'package:iot/pages/settingPage.dart';
import 'pages/eBilPage.dart';
import 'WifiController.dart'; // Import the wifi_controller.dart file

void main() {
  runApp(IoTApp());
}

class IoTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white70,
            fontSize: 24.0
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // colorScheme: ColorScheme.dark(background: Colors.white12)

      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id : (context) => HomePage(),
        SwitchPage.id: (context) => SwitchPage(),
        PowerUsagePage.id: (context) => PowerUsagePage(),
        SettingPage.id: (context) => SettingPage(),
        eBil.id: (context) => eBil(),
      },
    );
  }
}




