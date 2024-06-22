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

    final acRef = _databaseReference.child('LivingRoom/ACStatus/isLrACOn');
    final lightRef = _databaseReference.child('LivingRoom/Light1Status/isLrLight1On');
    final r1FanRef = _databaseReference.child('Room1/FanStatus/isR1FanOn');
    final r1Light1Ref = _databaseReference.child('Room1/Light1Status/isR1Light1On');
    final r1Light2Ref = _databaseReference.child('Room1/Light2Status/isR1Light2On');
    final r2FanRef = _databaseReference.child('Room2/FanStatus/isR2FanOn');
    final r2Light1Ref = _databaseReference.child('Room2/Light1Status/isR2Light1On');
    final r2Light2Ref = _databaseReference.child('Room2/Light2Status/isR2Light2On');
    final r2Light3Ref = _databaseReference.child('Room2/Light3Status/isR2Light3On');
    final r3FanRef = _databaseReference.child('Room3/FanStatus/isR3FanOn');
    final r3Light1Ref = _databaseReference.child('Room3/Light1Status/isR3Light1On');
    final r3Light2Ref = _databaseReference.child('Room3/Light2Status/isR3Light2On');
    final outdoorLight1Ref = _databaseReference.child('Outdoor/Light1Status/isOutdoorLight1On');
    final outdoorLight2Ref = _databaseReference.child('Outdoor/Light2Status/isOutdoorLight2On');
    final outdoorLight3Ref = _databaseReference.child('Outdoor/Light3Status/isOutdoorLight3On');
    final kLight1Ref = _databaseReference.child('Kitchen/Light1Status/isKLight1On');
    final kLight2Ref = _databaseReference.child('Kitchen/Light2Status/isKLight2On');

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
