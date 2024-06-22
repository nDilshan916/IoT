import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:iot/pages/settingPages/set_To_Off.dart';
import 'firebase_options.dart';
import 'notification_service.dart';
import 'usage_monitor_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/pages/homePage.dart';
import 'package:iot/pages/logIn/initialPage.dart';
import 'package:iot/pages/logIn/logInPage.dart';
import 'package:iot/pages/logIn/signUpPage.dart';
import 'package:iot/pages/settingPages/billCircle.dart';
import 'package:iot/pages/settingPages/reminderPage.dart';
import 'package:iot/pages/settingPages/setLimit.dart';
import 'package:iot/pages/settingPages/tecSupport.dart';
import 'package:iot/pages/subPages/KitchenPage.dart';
import 'package:iot/pages/subPages/Room_1_Page.dart';
import 'package:iot/pages/subPages/Room_2_Page.dart';
import 'package:iot/pages/subPages/Room_3_Page.dart';
import 'package:iot/pages/subPages/Outdoor.dart';
import 'package:iot/pages/switchPage.dart';
import 'package:iot/pages/settingPage.dart';
import 'package:iot/pages/PowerUsagePage.dart';
import 'pages/eBilPage.dart';
import 'package:iot/pages/subPages/LivingRoomPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  UsageMonitorService();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(IoTApp(isLoggedIn: isLoggedIn));
}

class IoTApp extends StatelessWidget {
  final bool isLoggedIn;
  const IoTApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
      ),
      initialRoute: isLoggedIn ? HomePage.id : InitialPage.id,
      routes: {
        InitialPage.id: (context) => const InitialPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        LogInPage.id: (context) => const LogInPage(),
        HomePage.id: (context) => const HomePage(),
        SwitchPage.id: (context) => const SwitchPage(),
        PowerUsagePage.id: (context) => const PowerUsagePage(),
        SettingPage.id: (context) => const SettingPage(),
        eBil.id: (context) => const eBil(),
        LivingRoomPage.id: (context) => const LivingRoomPage(),
        Room_1_Page.id: (context) => const Room_1_Page(),
        Room_2_Page.id: (context) => const Room_2_Page(),
        Room_3_Page.id: (context) => const Room_3_Page(),
        Outdoor.id: (context) => const Outdoor(),
        KitchenPage.id: (context) => const KitchenPage(),
        SetLimit.id: (context) => const SetLimit(),
        ReminderPage.id: (context) => const ReminderPage(),
        TecSupport.id: (context) => const TecSupport(),
        SetToOff.id: (context) => const SetToOff(),
      },
    );
  }
}
