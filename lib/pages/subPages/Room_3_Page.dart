import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../components/customSwitch.dart';

class Room_3_Page extends StatefulWidget {
  static const String id = 'Room3Page';

  const Room_3_Page({super.key});

  @override
  State<Room_3_Page> createState() => _Room_3_PageState();
}

class _Room_3_PageState extends State<Room_3_Page> {
  late bool isR3FanOn = false;
  late bool isR3Light1On = false;
  late bool isR3Light2On = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference fanRef = _databaseRef.child('Components/Room 3/Fan/isR3FanOn');
    final DatabaseReference light1Ref = _databaseRef.child('Components/Room 3/Light 1/isR3Light1On');
    final DatabaseReference light2Ref = _databaseRef.child('Components/Room 3/Light 2/isR3Light2On');

    fanRef.onValue.listen((event) {
      setState(() {
        isR3FanOn = event.snapshot.value as bool? ?? false;
      });
    });

    light1Ref.onValue.listen((event) {
      setState(() {
        isR3Light1On = event.snapshot.value as bool? ?? false;
      });
    });

    light2Ref.onValue.listen((event) {
      setState(() {
        isR3Light2On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheRealtimeDatabase(key, value);
  }

  Future<void> _updateTheRealtimeDatabase(String key, bool status) async {
    if (key == 'isR3FanOn') {
      await _databaseRef.child('Components/Room 3').child('Fan').set({
        'isR3FanOn': status,
      });
    } else if (key == 'isR3Light1On') {
      await _databaseRef.child('Components/Room 3').child('Light 1').set({
        'isR3Light1On': status,
      });
    } else if (key == 'isR3Light2On') {
      await _databaseRef.child('Components/Room 3').child('Light 2').set({
        'isR3Light2On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Room 3'),
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
                            isSwitchOn: isR3FanOn,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR3FanOn = !isR3FanOn;
                                  _saveSwitchState('isR3FanOn', isR3FanOn);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR3FanOn,),
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
                            isSwitchOn: isR3Light1On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR3Light1On = !isR3Light1On;
                                  _saveSwitchState('isR3Light1On', isR3Light1On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR3Light1On,),
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
                            isSwitchOn: isR3Light2On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isR3Light2On = !isR3Light2On;
                                  _saveSwitchState('isR3Light2On', isR3Light2On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isR3Light2On,),
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
            const bottomBar(currentPageId: Room_3_Page.id),
          ],
        ),
      ),
    );
  }
}
