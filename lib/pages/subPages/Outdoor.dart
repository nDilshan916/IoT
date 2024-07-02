import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../components/customSwitch.dart';

class Outdoor extends StatefulWidget {
  static const String id = 'Outdoor';

  const Outdoor({super.key});

  @override
  State<Outdoor> createState() => _OutdoorState();
}

class _OutdoorState extends State<Outdoor> {
  late bool isOutdoorLight1On = false;
  late bool isOutdoorLight2On = false;
  late bool isOutdoorLight3On = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference light1Ref = _databaseRef.child('Components/Outdoor/Light 1/isOutdoorLight1On');
    final DatabaseReference light2Ref = _databaseRef.child('Components/Outdoor/Light 2/isOutdoorLight2On');
    final DatabaseReference light3Ref = _databaseRef.child('Components/Outdoor/Light 3/isOutdoorLight3On');

    light1Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight1On = event.snapshot.value as bool? ?? false;
      });
    });

    light2Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight2On = event.snapshot.value as bool? ?? false;
      });
    });

    light3Ref.onValue.listen((event) {
      setState(() {
        isOutdoorLight3On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheRealtimeDatabase(key, value);
  }

  Future<void> _updateTheRealtimeDatabase(String key, bool status) async {
    if (key == 'isOutdoorLight1On') {
      await _databaseRef.child('Components/Outdoor').child('Light 1').set({
        'isOutdoorLight1On': status,
      });
    } else if (key == 'isOutdoorLight2On') {
      await _databaseRef.child('Components/Outdoor').child('Light 2').set({
        'isOutdoorLight2On': status,
      });
    } else if (key == 'isOutdoorLight3On') {
      await _databaseRef.child('Components/Outdoor').child('Light 3').set({
        'isOutdoorLight3On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Outdoor'),
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
                            switchImage: 'images/light_switch.png',
                            switchName: 'Light 1',
                            isSwitchOn: isOutdoorLight1On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOutdoorLight1On = !isOutdoorLight1On;
                                  _saveSwitchState('isOutdoorLight1On', isOutdoorLight1On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isOutdoorLight1On,),
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
                            isSwitchOn: isOutdoorLight2On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOutdoorLight2On = !isOutdoorLight2On;
                                  _saveSwitchState('isOutdoorLight2On', isOutdoorLight2On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isOutdoorLight2On,),
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
                            isSwitchOn: isOutdoorLight3On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOutdoorLight3On = !isOutdoorLight3On;
                                  _saveSwitchState('isOutdoorLight3On', isOutdoorLight3On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isOutdoorLight3On,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const bottomBar(currentPageId: Outdoor.id),
          ],
        ),
      ),
    );
  }
}
