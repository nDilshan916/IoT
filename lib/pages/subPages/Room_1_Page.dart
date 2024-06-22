import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

class Room_1_Page extends StatefulWidget {
  static const String id = 'Room1Page';

  const Room_1_Page({super.key});

  @override
  State<Room_1_Page> createState() => _Room_1_PageState();
}

class _Room_1_PageState extends State<Room_1_Page> {
  late bool isR1FanOn = false;
  late bool isR1Light1On = false;
  late bool isR1Light2On = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference fanRef = _databaseRef.child('Room1/FanStatus/isR1FanOn');
    final DatabaseReference light1Ref = _databaseRef.child('Room1/Light1Status/isR1Light1On');
    final DatabaseReference light2Ref = _databaseRef.child('Room1/Light2Status/isR1Light2On');

    fanRef.onValue.listen((event) {
      setState(() {
        isR1FanOn = event.snapshot.value as bool? ?? false;
      });
    });

    light1Ref.onValue.listen((event) {
      setState(() {
        isR1Light1On = event.snapshot.value as bool? ?? false;
      });
    });

    light2Ref.onValue.listen((event) {
      setState(() {
        isR1Light2On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheRealtimeDatabase(key, value);
  }

  Future<void> _updateTheRealtimeDatabase(String key, bool status) async {
    if (key == 'isR1FanOn') {
      await _databaseRef.child('Room1').child('FanStatus').set({
        'isR1FanOn': status,
      });
    } else if (key == 'isR1Light1On') {
      await _databaseRef.child('Room1').child('Light1Status').set({
        'isR1Light1On': status,
      });
    } else if (key == 'isR1Light2On') {
      await _databaseRef.child('Room1').child('Light2Status').set({
        'isR1Light2On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Room 1'),
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
                        isSwitchOn: isR1FanOn,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR1FanOn,
                          onChanged: (value) {
                            setState(() {
                              isR1FanOn = value;
                              _saveSwitchState('isR1FanOn', isR1FanOn);
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
                        isSwitchOn: isR1Light1On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR1Light1On,
                          onChanged: (value) {
                            setState(() {
                              isR1Light1On = value;
                              _saveSwitchState('isR1Light1On', isR1Light1On);
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
                        isSwitchOn: isR1Light2On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isR1Light2On,
                          onChanged: (value) {
                            setState(() {
                              isR1Light2On = value;
                              _saveSwitchState('isR1Light2On', isR1Light2On);
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
          const bottomBar(currentPageId: Room_1_Page.id),
        ],
      ),
    );
  }
}
