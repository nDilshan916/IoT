import 'package:flutter/material.dart';
import 'package:iot/pages/PowerUsagePage.dart';
import 'package:iot/pages/homePage.dart';
import 'package:iot/pages/logIn/initialPage.dart';
import 'package:iot/pages/logIn/logInPage.dart';
import 'package:iot/pages/logIn/signUpPage.dart';
import 'package:iot/pages/settingPages/billCircle.dart';
import 'package:iot/pages/settingPages/setLimit.dart';
import 'package:iot/pages/settingPages/tecSupport.dart';
import 'package:iot/pages/subPages/KitchenPage.dart';
import 'package:iot/pages/subPages/Room_1_Page.dart';
import 'package:iot/pages/subPages/Room_2_Page.dart';
import 'package:iot/pages/subPages/Room_3_Page.dart';
import 'package:iot/pages/subPages/Outdoor.dart';
import 'package:iot/pages/switchPage.dart';
import 'package:iot/pages/settingPage.dart';
import 'firebase_options.dart';
import 'pages/eBilPage.dart';
import 'package:iot/pages/subPages/LivingRoomPage.dart';
import 'package:firebase_core/firebase_core.dart';
// Import the wifi_controller.dart file

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: InitialPage.id,
      routes: {
        InitialPage.id: (context) => const InitialPage(),
        SignUpPage.id: (context) =>  SignUpPage(),
        LogInPage.id: (context) => const LogInPage(),
        HomePage.id: (context) =>  const HomePage(),
        SwitchPage.id: (context) => const SwitchPage(),
        PowerUsagePage.id: (context) =>  const PowerUsagePage(),
        SettingPage.id: (context) =>  const SettingPage(),
        eBil.id: (context) => const eBil(),
        LivingRoomPage.id: (context) => const LivingRoomPage(),
        Room_1_Page.id: (context) => const Room_1_Page(),
        Room_2_Page.id: (context) => const Room_2_Page(),
        Room_3_Page.id: (context) => const Room_3_Page(),
        Outdoor.id: (context) => const Outdoor(),
        KitchenPage.id: (context) => const KitchenPage(),
        SetLimit.id: (context) => const SetLimit(currentLimit: 0,),
        TecSupport.id: (context) => const TecSupport(),
        BillCircle.id: (context) =>  const BillCircle(),
      },
    );
  }
}
