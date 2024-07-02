import 'package:firebase_database/firebase_database.dart';
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

import '../main.dart';

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

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchStates();
  }

  void _loadSwitchStates() async {

    final acRef = _databaseReference.child('Components/LivingRoom/AC/isLrACOn');
    final lightRef = _databaseReference.child('Components/LivingRoom/Light 1/isLrLight1On');
    final r1FanRef = _databaseReference.child('Components/Room 1/Fan/isR1FanOn');
    final r1Light1Ref = _databaseReference.child('Components/Room 1/Light 1/isR1Light1On');
    final r1Light2Ref = _databaseReference.child('Components/Room 1/Light 2/isR1Light2On');
    final r2FanRef = _databaseReference.child('Components/Room 2/Fan/isR2FanOn');
    final r2Light1Ref = _databaseReference.child('Components/Room 2/Light 1/isR2Light1On');
    final r2Light2Ref = _databaseReference.child('Components/Room 2/Light 2/isR2Light2On');
    final r2Light3Ref = _databaseReference.child('Components/Room 2/Light 3/isR2Light3On');
    final r3FanRef = _databaseReference.child('Components/Room 3/Fan/isR3FanOn');
    final r3Light1Ref = _databaseReference.child('Components/Room 3/Light 1/isR3Light1On');
    final r3Light2Ref = _databaseReference.child('Components/Room 3/Light 2/isR3Light2On');
    final outdoorLight1Ref = _databaseReference.child('Components/Outdoor/Light 1/isOutdoorLight1On');
    final outdoorLight2Ref = _databaseReference.child('Components/Outdoor/Light 2/isOutdoorLight2On');
    final outdoorLight3Ref = _databaseReference.child('Components/Outdoor/Light 3/isOutdoorLight3On');
    final kLight1Ref = _databaseReference.child('Components/Kitchen/Light 1/isKLight1On');
    final kLight2Ref = _databaseReference.child('Components/Kitchen/Light 2/isKLight2On');

    acRef.onValue.listen((event) {
      setState(() {
        isLrACOn = event.snapshot.value as bool? ?? false;
        isLivingRoomOn = isLrACOn || isLrLight1On;
      });
    });

    lightRef.onValue.listen((event) {
      setState(() {
        isLrLight1On = event.snapshot.value as bool? ?? false;
        isLivingRoomOn = isLrACOn || isLrLight1On;
      });
    });

    r1FanRef.onValue.listen((event) {
      setState(() {
        isR1FanOn = event.snapshot.value as bool? ?? false;
        isRoom1On = isR1FanOn || isR1Light1On || isR1Light2On;
      });
    });

    r1Light1Ref.onValue.listen((event) {
      setState(() {
        isR1Light1On = event.snapshot.value as bool? ?? false;
        isRoom1On = isR1FanOn || isR1Light1On || isR1Light2On;
      });
    });

    r1Light2Ref.onValue.listen((event) {
      setState(() {
        isR1Light2On = event.snapshot.value as bool? ?? false;
        isRoom1On = isR1FanOn || isR1Light1On || isR1Light2On;
      });
    });

    r2FanRef.onValue.listen((event) {
      setState(() {
        isR2FanOn = event.snapshot.value as bool? ?? false;
        isRoom2On = isR2FanOn || isR2Light1On || isR2Light2On || isR2Light3On;
      });
    });

    r2Light1Ref.onValue.listen((event) {
      setState(() {
        isR2Light1On = event.snapshot.value as bool? ?? false;
        isRoom2On = isR2FanOn || isR2Light1On || isR2Light2On || isR2Light3On;
      });
    });

    r2Light2Ref.onValue.listen((event) {
      setState(() {
        isR2Light2On = event.snapshot.value as bool? ?? false;
        isRoom2On = isR2FanOn || isR2Light1On || isR2Light2On || isR2Light3On;
      });
    });

    r2Light3Ref.onValue.listen((event) {
      setState(() {
        isR2Light3On = event.snapshot.value as bool? ?? false;
        isRoom2On = isR2FanOn || isR2Light1On || isR2Light2On || isR2Light3On;
      });
    });

    r3FanRef.onValue.listen((event) {
      setState(() {
        isR3FanOn = event.snapshot.value as bool? ?? false;
        isRoom3On = isR3FanOn || isR3Light1On || isR3Light2On;
      });
    });

    r3Light1Ref.onValue.listen((event) {
      setState(() {
        isR3Light1On = event.snapshot.value as bool? ?? false;
        isRoom3On = isR3FanOn || isR3Light1On || isR3Light2On;
      });
    });

    r3Light2Ref.onValue.listen((event) {
      setState(() {
        isR3Light2On = event.snapshot.value as bool? ?? false;
        isRoom3On = isR3FanOn || isR3Light1On || isR3Light2On;
      });
    });

    outdoorLight1Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight1On = event.snapshot.value as bool? ?? false;
        isOutdoorOn = isOutdoorLight1On || isOutdoorLight2On || isOutdoorLight3On;
      });
    });

    outdoorLight2Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight2On = event.snapshot.value as bool? ?? false;
        isOutdoorOn = isOutdoorLight1On || isOutdoorLight2On || isOutdoorLight3On;
      });
    });

    outdoorLight3Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight3On = event.snapshot.value as bool? ?? false;
        isOutdoorOn = isOutdoorLight1On || isOutdoorLight2On || isOutdoorLight3On;
      });
    });

    kLight1Ref.onValue.listen((event) {
      setState(() {
        isKLight1On = event.snapshot.value as bool? ?? false;
        isKitchenOn = isKLight1On || isKLight2On;
      });
    });

    kLight2Ref.onValue.listen((event) {
      setState(() {
        isKLight2On = event.snapshot.value as bool? ?? false;
        isKitchenOn = isKLight1On || isKLight2On;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double switchGap = 20.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Switches'),
      ),
      body: withDraggableFAB(Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
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
                      SizedBox(height: switchGap),
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
                      SizedBox(height: switchGap),
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
                                switchImage: 'images/outdoor.png',
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
              ),
            ),
            const bottomBar(currentPageId: SwitchPage.id),
          ],
        ),
      )),
    );
  }
}
