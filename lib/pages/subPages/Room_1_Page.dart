import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isR1FanOn = prefs.getBool('isR1FanOn') ?? false;
      isR1Light1On = prefs.getBool('isR1Light1On') ?? false;
      isR1Light2On = prefs.getBool('isR1Light2On') ?? false;
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheFireStore(key, value);
  }

  Future<void> _updateTheFireStore(String key, bool status) async {
    if (key == 'isR1FanOn') {
      await _firestore.collection('Room1').doc('FanStatus').set({
        'isR1FanOn': status,
      });
    } else if (key == 'isR1Light1On') {
      await _firestore.collection('Room1').doc('Light1Status').set({
        'isR1Light1On': status,
      });
    } else if (key == 'isR1Light2On') {
      await _firestore.collection('Room1').doc('Light2Status').set({
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
