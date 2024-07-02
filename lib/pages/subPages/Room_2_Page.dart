import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../components/customSwitch.dart';

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
    final DatabaseReference fanRef = _databaseRef.child('Components/Room 2/Fan/isR2FanOn');
    final DatabaseReference light1Ref = _databaseRef.child('Components/Room 2/Light 1/isR2Light1On');
    final DatabaseReference light2Ref = _databaseRef.child('Components/Room 2/Light 2/isR2Light2On');
    final DatabaseReference light3Ref = _databaseRef.child('Components/Room 2/Light 3/isR2Light3On');

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
      await _databaseRef.child('Components/Room 2').child('Fan').set({
        'isR2FanOn': status,
      });
    } else if (key == 'isR2Light1On') {
      await _databaseRef.child('Components/Room 2').child('Light 1').set({
        'isR2Light1On': status,
      });
    } else if (key == 'isR2Light2On') {
      await _databaseRef.child('Components/Room 2').child('Light 2').set({
        'isR2Light2On': status,
      });
    } else if (key == 'isR2Light3On') {
      await _databaseRef.child('Components/Room 2').child('Light 3').set({
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
            Expanded(
              child: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/fan_switch.png',
                            switchName: 'Fan',
                            isSwitchOn: isR2FanOn,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR2FanOn = !isR2FanOn;
                                  _saveSwitchState('isR2FanOn', isR2FanOn);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR2FanOn,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/light_switch.png',
                            switchName: 'Light 1',
                            isSwitchOn: isR2Light1On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR2Light1On = !isR2Light1On;
                                  _saveSwitchState('isR2Light1On', isR2Light1On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR2Light1On,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/light_switch.png',
                            switchName: 'Light 2',
                            isSwitchOn: isR2Light2On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR2Light2On = !isR2Light2On;
                                  _saveSwitchState('isR2Light2On', isR2Light2On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR2Light2On,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/light_switch.png',
                            switchName: 'Light 3',
                            isSwitchOn: isR2Light3On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR2Light3On = !isR2Light3On;
                                  _saveSwitchState('isR2Light3On', isR2Light3On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR2Light3On,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const bottomBar(currentPageId: Room_2_Page.id),
          ],
        ),
      ),
    );
  }
}
