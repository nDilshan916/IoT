import 'package:flutter/material.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../components/customSwitch.dart';
import '../../components/reusable_card.dart';

class LivingRoomPage extends StatefulWidget {
  static const String id = 'LivingRoomPage';

  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  late bool isLrACOn = false;
  late bool isLrLight1On = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference acRef = _databaseReference.child('Components/LivingRoom/AC/isLrACOn');
    final DatabaseReference lightRef = _databaseReference.child('Components/LivingRoom/Light 1/isLrLight1On');

    acRef.onValue.listen((event) {
      setState(() {
        isLrACOn = event.snapshot.value as bool? ?? false;
      });
    });

    lightRef.onValue.listen((event) {
      setState(() {
        isLrLight1On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    // Update Firebase Realtime Database
    await _updateRealtimeDatabase(key, value);
  }

  Future<void> _updateRealtimeDatabase(String key, bool status) async {
    if (key == 'isLrACOn') {
      await _databaseReference.child('Components/LivingRoom/AC').set({
        'isLrACOn': status,
      });
    } else if (key == 'isLrLight1On') {
      await _databaseReference.child('Components/LivingRoom/Light 1').set({
        'isLrLight1On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Living Room'),
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
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: SizedBox(
                width: 300.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/AC_switch.png',
                            switchName: 'AC',
                            isSwitchOn: isLrACOn,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLrACOn = !isLrACOn;
                                  _saveSwitchState('isLrACOn', isLrACOn);
                                });
                              },
                            child: CustomSwitch(isSwitched: isLrACOn,),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Stack(
                        children: [
                          SwitchCards(
                            switchImage: 'images/light_switch.png',
                            switchName: 'Light 1',
                            isSwitchOn: isLrLight1On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLrLight1On = !isLrLight1On;
                                  _saveSwitchState('isLrLight1On', isLrLight1On);
                                });
                              },
                            child: CustomSwitch(isSwitched: isLrLight1On,),
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const bottomBar(currentPageId: LivingRoomPage.id),
          ],
        ),
      ),
    );
  }
}
