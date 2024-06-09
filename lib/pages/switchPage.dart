import 'package:flutter/material.dart';
import 'package:iot/pages/subPages/Room_2_Page.dart';
import 'package:iot/pages/subPages/Room_3_Page.dart';
import 'package:iot/pages/subPages/Outdoor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:iot/pages/subPages/KitchenPage.dart';
import 'package:iot/pages/subPages/LivingRoomPage.dart';
import 'package:iot/pages/subPages/Room_1_Page.dart';

class SwitchPage extends StatefulWidget {
  static const String id = 'SwitchPage';

  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  //Living Room
  bool isLivingRoomOn = false;
  bool isLrACOn = false;
  bool isLrLight1On = false;

  //room 1
  bool isRoom1On = false;
  bool isR1FanOn = false;
  bool isR1Light1On = false;
  bool isR1Light2On = false;

  //room 2
  bool isRoom2On = false;
  bool isR2FanOn = false;
  bool isR2Light1On = false;
  bool isR2Light2On = false;
  bool isR2Light3On = false;

  //room 3
  bool isRoom3On = false;
  bool isR3FanOn = false;
  bool isR3Light1On = false;
  bool isR3Light2On = false;

  //outdoor
  bool isOutdoorOn = false;
  bool isOutdoorLight1On = false;
  bool isOutdoorLight2On = false;
  bool isOutdoorLight3On = false;

  //kitchen
  bool isKitchenOn = false;
  bool isKLight1On = false;
  bool isKLight2On = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isR1FanOn = prefs.getBool('isR1FanOn') ?? false;
      isR1Light1On = prefs.getBool('isR1Light1On') ?? false;
      isR1Light2On = prefs.getBool('isR1Light2On') ?? false;

      isR2FanOn = prefs.getBool('isR2FanOn') ?? false;
      isR2Light1On = prefs.getBool('isR2Light1On') ?? false;
      isR2Light2On = prefs.getBool('isR2Light2On') ?? false;
      isR2Light3On = prefs.getBool('isR2Light3On') ?? false;

      isR3FanOn = prefs.getBool('isR3FanOn') ?? false;
      isR3Light1On = prefs.getBool('isR3Light1On') ?? false;
      isR3Light2On = prefs.getBool('isR3Light2On') ?? false;

      isOutdoorLight1On = prefs.getBool('isOutdoorLight1On') ?? false;
      isOutdoorLight2On = prefs.getBool('isOutdoorLight2On') ?? false;
      isOutdoorLight3On = prefs.getBool('isOutdoorLight3On') ?? false;

      isLrACOn = prefs.getBool('isLrACOn') ?? false;
      isLrLight1On = prefs.getBool('isLrLight1On') ?? false;

      isKLight1On = prefs.getBool('isKLight1On') ?? false;
      isKLight2On = prefs.getBool('isKLight2On') ?? false;

      isRoom1On = isR1FanOn || isR1Light1On || isR1Light2On;
      isRoom2On = isR2FanOn || isR2Light1On || isR2Light2On || isR2Light3On;
      isRoom3On = isR3FanOn || isR3Light1On || isR3Light2On;
      isOutdoorOn = isOutdoorLight1On || isOutdoorLight2On || isOutdoorLight3On;
      isLivingRoomOn = isLrACOn || isLrLight1On;
      isKitchenOn = isKLight1On || isKLight2On;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Switch Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LivingRoomPage.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/living room switch.png',
                            switchName: 'Living Room',
                            isSwitchOn:
                                isLivingRoomOn, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Room_1_Page.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 1',
                            isSwitchOn: isRoom1On,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Room_2_Page.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 2',
                            isSwitchOn: isRoom2On, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Room_3_Page.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Room 3',
                            isSwitchOn: isRoom3On, // Assuming false for demo
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, KitchenPage.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/kitchen button.png',
                            switchName: 'Kitchen',
                            isSwitchOn: isKitchenOn, // Assuming false for demo
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Outdoor.id)
                                .then((_) {
                              _loadSwitchStates(); // Reload switch states when coming back
                            });
                          },
                          child: SwitchCards(
                            switchImage: 'images/room switch.png',
                            switchName: 'Outdoor',
                            isSwitchOn: isOutdoorOn, // Assuming false for demo
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const bottomBar(currentPageId: SwitchPage.id),
          ],
        ),
      ),
    );
  }
}
