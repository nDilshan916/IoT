import 'package:flutter/material.dart';
import 'package:iot/pages/PowerUsagePage.dart';
import 'package:iot/pages/homePage.dart';
import 'package:iot/pages/subPages/KitchenPage.dart';
import 'package:iot/pages/subPages/Room_1_Page.dart';
import 'package:iot/pages/switchPage.dart';
import 'package:iot/pages/settingPage.dart';
import 'pages/eBilPage.dart';
import 'package:iot/pages/subPages/LivingRoomPage.dart';
// Import the wifi_controller.dart file

void main() {
  runApp(const IoTApp());
}

class IoTApp extends StatelessWidget {
  const IoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white70, fontSize: 24.0),
          iconTheme: IconThemeData(
            color: Colors.white, // change the back arrow color
          ),
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
        // colorScheme: ColorScheme.dark(background: Colors.white12)
      ),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
        SwitchPage.id: (context) => const SwitchPage(),
        PowerUsagePage.id: (context) =>  const PowerUsagePage(),
        SettingPage.id: (context) => const SettingPage(),
        eBil.id: (context) => const eBil(),
        LivingRoomPage.id: (context) => const LivingRoomPage(),
        Room_1_Page.id: (context) => const Room_1_Page(),
        KitchenPage.id: (context) => const KitchenPage(),
      },
    );
  }
}
