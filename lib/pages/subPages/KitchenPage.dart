import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

class KitchenPage extends StatefulWidget {
  static const String id = 'KitchenPage';

  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPage();
}

class _KitchenPage extends State<KitchenPage> {
  late bool isKLight1On = false;
  late bool isKLight2On = false;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    final DatabaseReference light1Ref = _databaseRef.child('Kitchen/Light1Status/isKLight1On');
    final DatabaseReference light2Ref = _databaseRef.child('Kitchen/Light2Status/isKLight2On');

    light1Ref.onValue.listen((event) {
      setState(() {
        isKLight1On = event.snapshot.value as bool? ?? false;
      });
    });

    light2Ref.onValue.listen((event) {
      setState(() {
        isKLight2On = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    await _updateTheRealtimeDatabase(key, value);
  }

  Future<void> _updateTheRealtimeDatabase(String key, bool status) async {
    if (key == 'isKLight1On') {
      await _databaseRef.child('Kitchen').child('Light1Status').set({
        'isKLight1On': status,
      });
    } else if (key == 'isKLight2On') {
      await _databaseRef.child('Kitchen').child('Light2Status').set({
        'isKLight2On': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Kitchen'),
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
                        isSwitchOn: isKLight1On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isKLight1On,
                          onChanged: (value) {
                            setState(() {
                              isKLight1On = value;
                              _saveSwitchState('isKLight1On', isKLight1On);
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
                        isSwitchOn: isKLight2On,
                      ),
                      Positioned(
                        bottom: 1,
                        right: 20,
                        child: Switch(
                          value: isKLight2On,
                          onChanged: (value) {
                            setState(() {
                              isKLight2On = value;
                              _saveSwitchState('isKLight2On', isKLight2On);
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
          const bottomBar(currentPageId: KitchenPage.id),
        ],
      ),
    );
  }
}
