import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iot/components/bottom_bar.dart';
import 'package:iot/components/reusable_card.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../components/customSwitch.dart';

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
    final DatabaseReference light1Ref = _databaseRef.child('Components/Kitchen/Light 1/isKLight1On');
    final DatabaseReference light2Ref = _databaseRef.child('Components/Kitchen/Light 2/isKLight2On');

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
      await _databaseRef.child('Components/Kitchen').child('Light 1').set({
        'isKLight1On': status,
      });
    } else if (key == 'isKLight2On') {
      await _databaseRef.child('Components/Kitchen').child('Light 2').set({
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
                            isSwitchOn: isKLight1On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isKLight1On = !isKLight1On;
                                  _saveSwitchState('isKLight1On', isKLight1On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isKLight1On),
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
                            isSwitchOn: isKLight2On,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 25,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isKLight2On = !isKLight2On;
                                  _saveSwitchState('isKLight2On', isKLight2On);
                                });
                              },
                              child: CustomSwitch(isSwitched: isKLight2On),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const bottomBar(currentPageId: KitchenPage.id),
          ],
        ),
      ),
    );
  }
}


