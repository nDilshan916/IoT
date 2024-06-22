import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

class Room_2_Page extends StatefulWidget {
  static const String id = 'Room2Page';

  const Room_2_Page({super.key});

  @override
  State<Room_2_Page> createState() => _Room_2_PageState();
}

class _Room_2_PageState extends State<Room_2_Page> {
  late bool isR2FanOn = false;
  late bool isR2Light1On = false;
  late bool isR2Light2On = false;
  late bool isR2Light3On = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference fanRef = _databaseRef.child('Room2/FanStatus/isR2FanOn');
    final DatabaseReference light1Ref = _databaseRef.child('Room2/Light1Status/isR2Light1On');
    final DatabaseReference light2Ref = _databaseRef.child('Room2/Light2Status/isR2Light2On');
    final DatabaseReference light3Ref = _databaseRef.child('Room2/Light3Status/isR2Light3On');

    fanRef.onValue.listen((event) {
      setState(() {
        isR2FanOn = event.snapshot.value as bool? ?? false;
      });
    });

    light1Ref.onValue.listen((event) {
      setState(() {
        isR2Light1On = event.snapshot.value as bool? ?? false;
      });
    });

    light2Ref.onValue.listen((event) {
      setState(() {
        isR2Light2On = event.snapshot.value as bool? ?? false;
      });
    });

    light3Ref.onValue.listen((event) {
      setState(() {
        isR2Light3On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheRealtimeDatabase(key, value);
  }

  Future<void> _updateTheRealtimeDatabase(String key, bool status) async {
    if (key == 'isR2FanOn') {
      await _databaseRef.child('Room2').child('FanStatus').set({
        'isR2FanOn': status,
      });
    } else if (key == 'isR2Light1On') {
      await _databaseRef.child('Room2').child('Light1Status').set({
        'isR2Light1On': status,
      });
    } else if (key == 'isR2Light2On') {
      await _databaseRef.child('Room2').child('Light2Status').set({
        'isR2Light2On': status,
      });
    } else if (key == 'isR2Light3On') {
      await _databaseRef.child('Room2').child('Light3Status').set({
        'isR2Light3On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Room 2'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/fan_switch.png',
                        switchName: 'Fan',
                        isSwitchOn: isR2FanOn,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR2FanOn,
                          onChanged: (value) {
                            setState(() {
                              isR2FanOn = value;
                              _saveSwitchState('isR2FanOn', isR2FanOn);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/light_switch.png',
                        switchName: 'Light 1',
                        isSwitchOn: isR2Light1On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR2Light1On,
                          onChanged: (value) {
                            setState(() {
                              isR2Light1On = value;
                              _saveSwitchState('isR2Light1On', isR2Light1On);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/light_switch.png',
                        switchName: 'Light 2',
                        isSwitchOn: isR2Light2On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR2Light2On,
                          onChanged: (value) {
                            setState(() {
                              isR2Light2On = value;
                              _saveSwitchState('isR2Light2On', isR2Light2On);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SwitchCards(
                        switchImage: 'images/light_switch.png',
                        switchName: 'Light 3',
                        isSwitchOn: isR2Light3On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR2Light3On,
                          onChanged: (value) {
                            setState(() {
                              isR2Light3On = value;
                              _saveSwitchState('isR2Light3On', isR2Light3On);
                            });
                          },
                          activeTrackColor: Colors.white70,
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const bottomBar(currentPageId: Room_2_Page.id),
        ],
      ),
    );
  }
}
