import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

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
    final DatabaseReference light1Ref = _databaseRef.child('Outdoor/Light1Status/isOutdoorLight1On');
    final DatabaseReference light2Ref = _databaseRef.child('Outdoor/Light2Status/isOutdoorLight2On');
    final DatabaseReference light3Ref = _databaseRef.child('Outdoor/Light3Status/isOutdoorLight3On');

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
      await _databaseRef.child('Outdoor').child('Light1Status').set({
        'isOutdoorLight1On': status,
      });
    } else if (key == 'isOutdoorLight2On') {
      await _databaseRef.child('Outdoor').child('Light2Status').set({
        'isOutdoorLight2On': status,
      });
    } else if (key == 'isOutdoorLight3On') {
      await _databaseRef.child('Outdoor').child('Light3Status').set({
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
                        switchImage: 'images/light_switch.png',
                        switchName: 'Light 1',
                        isSwitchOn: isOutdoorLight1On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isOutdoorLight1On,
                          onChanged: (value) {
                            setState(() {
                              isOutdoorLight1On = value;
                              _saveSwitchState('isOutdoorLight1On', isOutdoorLight1On);
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
                        isSwitchOn: isOutdoorLight2On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isOutdoorLight2On,
                          onChanged: (value) {
                            setState(() {
                              isOutdoorLight2On = value;
                              _saveSwitchState('isOutdoorLight2On', isOutdoorLight2On);
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
                        isSwitchOn: isOutdoorLight3On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isOutdoorLight3On,
                          onChanged: (value) {
                            setState(() {
                              isOutdoorLight3On = value;
                              _saveSwitchState('isOutdoorLight3On', isOutdoorLight3On);
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
          const bottomBar(currentPageId: Outdoor.id),
        ],
      ),
    );
  }
}
